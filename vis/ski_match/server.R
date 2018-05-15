
shinyServer(function(input, output, session) {
   
  output$selected_nski <- renderText({ 
    paste("Approximate race size: ", round(10^input$n_ski, digits = -1))
  })
  
  observeEvent(input$update, {
    output$reccomended_race <- renderText({
    #lambdas
    pace_lambda = -0.142847
    dist_lambda = 0.37763
    nski_lambda = 0.528469
    
    #transform
    bc_my_pace = (isolate(input$pace)^pace_lambda - 1) / pace_lambda
    bc_my_dist = (isolate(input$distance)^dist_lambda - 1) / dist_lambda
    bc_my_nski = (isolate(round(10^input$n_ski, digits = -1))^nski_lambda - 1) / nski_lambda
    
    # append newly generated row to df
    knn_df <- ski_df %>% 
      filter(style == isolate(input$style)) %>%  #filter for style, by month?
      select(2:5) %>% 
      bind_rows(., c(bc_dist = bc_my_dist, bc_pace = bc_my_pace, bc_nski = bc_my_nski))
    
    # impute based on model 
    pred_host = kNN(knn_df, k = 39)
    
    # find a new race destination!
    # known df size, select first row (imputed host country)
    #  session$userData$host_var = pred_host[143833, 1] # attmpt at extracting variable for link elsewhere
    #pass value for output
    paste("Reccomended race: ", pred_host[143833, 1])
    
    })
  })

  output$example <- renderPlotly({
    #log scale isn't 1:1 for the actual model, but this early visualization I generated is a sufficient tool
    #to explain the idea behind the reccomendation with aggregate data from the same dataset
    example_df$euk_dist = sqrt((log(example_df$median_pace) - log(8.9))^2 + (log(example_df$distance) - log(21))^2 +
                             (log(example_df$n_skiiers) - log(60))^2)
    
    plot_ly(example_df, x = ~log(distance), y = ~log(max_pace), z = ~log(n_skiiers),
                  text = ~paste(host_country, " ", euk_dist) ,
                  marker = list(color = ~euk_dist, colorscale = 'Blackbody', 
                                reversescale = F, showscale = TRUE)) %>%
      add_markers() %>%
      layout(scene = list(xaxis = list(title = 'Distance'),
                          yaxis = list(title = 'Pace'),
                          zaxis = list(title = 'Skiiers')))
  })

  output$ski_map <- renderLeaflet({
    m <- leaflet(latlong_df) %>%
      addProviderTiles("Stamen.Watercolor")  %>% 
      addMarkers(lng = ~long, lat = ~lat, label = ~abrev, popup = ~url,
                 labelOptions = labelOptions(noHide = T, textsize = "15px"))
    m
  })
  
# possibly integrate more interactive element by extracting country abbrev from the update reactive
  # center <- reactive({
  #   subset(data, nom == input$canton) 
  #   # or whatever operation is needed to transform the selection 
  #   # to an object that contains lat and long
  # })
  # 
  # observe({
  #   leafletProxy('map') %>% 
  #     setView(lng =  center()$long, lat = center()$lat, zoom = 12)
  # })
  
  
  
  
  
})
