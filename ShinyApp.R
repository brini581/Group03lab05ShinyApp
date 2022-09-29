library(shiny)
library(shinythemes)
library(shinyvalidate)
library(Group03lab05package)

# Define FluidPage
ui <- fluidPage(
  navbarPage(
    "",theme = shinytheme("lumen"),
    tabPanel(
      "Home", fluid = TRUE, icon = icon("fa-solid fa-house"),
      sidebarLayout(
        sidebarPanel(
          
          textInput(inputId="country", label="Name of Country", width = "220px"),
          
          # Select Type of Map
          selectInput(inputId = "maptype",
                      label = "Select Map Type",
                      choices = c("Terrain"='terrain', "Toner"='toner',"Water Color"='watercolor'),
                      selected = "Terrain",
                      width = "220px"
          ),
          sliderInput(inputId = "zoom",
                      label = "Zoom Map",
                      min = 1,
                      max = 5,
                      value = c(5),
                      width = "220px")
          #Zoom Issue
        ),
        mainPanel(
          column(12,
                 
                 plotOutput("map",width = "100%", height = "400px")
          )
        )
      )
    )
    
  )# navbarPage
) 

# Define server function  
server <- function(input, output) {
  
  
  result_map <- reactive({
    in_val <- InputValidator$new()
    in_val$add_rule("country", sv_required())
    in_val$enable()
    
    coordinates <- get_country_coordinates(tolower(str_replace_all(input$country," ",".")))
    print(coordinates)
    req_stamen_map(coordinates[1],coordinates[2],coordinates[3],coordinates[4],input$zoom,input$maptype)
    
  })
  
  output$map <- renderPlot({result_map()})

} # server


# Create Shiny object
shinyApp(ui = ui, server = server)
