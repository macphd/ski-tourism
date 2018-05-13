
shinyServer(function(input, output) {
   
  output$selected_nski <- renderText({ 
    paste("Approximate race size: ", round(10^input$n_ski, digits = -1))
  })

  
  
  observeEvent(input$update, {
    output$reccomended_race <- renderPrint({
    #lambdas
    pace_lambda = -0.142847
    dist_lambda = 0.37763
    nski_lambda = 0.528469
    
    #transform
    bc_my_pace = ((input$pace)^pace_lambda - 1) / pace_lambda
    bc_my_dist = ((input$distance)^dist_lambda - 1) / dist_lambda
    bc_my_nski = ((round(10^input$n_ski, digits = -1))^nski_lambda - 1) / nski_lambda
    
    # append newly generated row to df
    knn_df <- ski_df %>% 
      filter(style == input$style) %>%  #filter for style, by month?
      select(2:5) %>% 
      bind_rows(., c(bc_dist = bc_my_dist, bc_pace = bc_my_pace, bc_nski = bc_my_nski))
    
    # impute based on model 
    pred_host = kNN(knn_df, k = 39)
    
    # find a new race destination!
    pred_host %>% 
      filter(host_country_imp == TRUE) %>% 
      select(host_country)
    })
  })
  
})
