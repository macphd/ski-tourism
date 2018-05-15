
shinyUI(

  navbarPage("Ski the world!",
             tabPanel("Reccomend a race",
                      sidebarLayout(
                        sidebarPanel(
                          radioButtons("style", h3("Select XC style:"),
                                       c("Classic/CT" = "CT", "Skate/FT" = "FT")),
                          sliderInput("distance", label = h3("Distance (km)"), min = 10, 
                                      max = 100, value = 21),
                          sliderInput("pace", label = h3("Speed (km/hr)"), min = 2, 
                                      max = 27, value = 8.9, step = 0.1),
                          sliderInput("n_ski", label = h3("Number of racers: 10^x"), min = 1, 
                                      max = 4.2, value = 1.85, step = 0.05),
                          h4(textOutput("selected_nski")),
                          hr(),
                          actionButton("update", h5("Find a match!"))
                        ),
                        mainPanel(
                          leafletOutput("ski_map"),
                          h1(textOutput("reccomended_race")),
                          tags$blockquote(h2(em("Free your heel, free your mind...")))
                          )
                      )
              ),
              tabPanel("Reccomendation engine",
                        splitLayout(
                        h3("details about KNN, training"),
                        plotlyOutput("example")
                        )
              ),
              tabPanel("About me",
                        h3("details about me")
                      )
             
             )
  
)

