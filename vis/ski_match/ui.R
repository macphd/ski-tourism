
shinyUI(

  navbarPage("Ski the world!",
             tabPanel("Overview",
                      sidebarLayout(
                        sidebarPanel(
                          tags$blockquote(h2(em("Free your heel, free your mind..."))),
                          h6("support text/ images")
                        ),
                        mainPanel(
                          h3("Map with geolocs here")
                        )
                      )
             ),
             tabPanel("Reccomend a race",
                      sidebarLayout(
                        sidebarPanel(
                          radioButtons("style", h3("Select XC style:"),
                                       c("Classic/CT" = "CT", "Skate/FT" = "FT")),
                          sliderInput("distance", label = h3("Distance (km)"), min = 10, 
                                      max = 100, value = 20),
                          sliderInput("pace", label = h3("Speed (km/hr)"), min = 2, 
                                      max = 27, value = 8.7, step = 0.1),
                          sliderInput("n_ski", label = h3("Number of racers: 10^x"), min = 1, 
                                      max = 4.2, value = 1.9, step = 0.05),
                          h4(textOutput("selected_nski")),
                          hr(),
                          actionButton("update", h5("Find a match!"))
                        ),
                        mainPanel(
                          verbatimTextOutput("reccomended_race")
                        )
                      )
             ),
             navbarMenu("More",
                        tabPanel("Reccomendation engine",
                                 h3("details about KNN, training")
                        ),
                        tabPanel("About me",
                                 h3("details about me")
                        )
             )
  )
)

