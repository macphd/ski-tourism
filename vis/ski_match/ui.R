
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
                          verticalLayout(
                            h3("Using KNN classification to reccomend a race"),
                            "A user selects parameters of race speed, distance, and 
                            size they want to participate in.",
                            "These generate a point in space.", 
                            "The distance between this and every other point in the plot is calculated.",
                            "This distance is visualized by color in the graph.",
                            "Dark red points are close to the input, while light blue points are far.",
                            "The model generates consensus by looking at points that are closest to it.",
                            "The race with the most adjacent points represesents the best fit, and is reccomended 
                            to the user.",
                            br(),
                            "This information is also valuable for FIS Worldloppet.",
                            "Follow up marketing can suggest new experiences for racers based on prior preferences.",
                            "For additional info, check out my blogpost (coming soon)."
                          ),
                          verticalLayout(
                            plotlyOutput("example"),
                            h4("A simplified KNN representation used in this web-app."),
                            h6("There are 300 points in this figure, the model uses about 300,000 real race
                               results scraped from the FIS Worldloppet website."))
                        )
              ),
              tabPanel("About me",
                        h3("Hi, I'm Mike!"),
                        h5("I am an avid cross country skiier who wants to become a Worldloppet Master some day."),
                        h5("I am pursuing a career in data science to fund these world travels!"),
                        h5("Thanks for looking at this app. Questions? Comments? Let's connect:"),
                        tags$a(href="https://www.linkedin.com/in/mikeacaballero/", "My LinkedIn")
                      )
             
             )
  
)

