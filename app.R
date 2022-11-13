# load libraries
library(shiny)
library(shinythemes)
library(shinydashboard)
library(plotly)
library(COVID19)

# Define UI for application
ui <- fluidPage(
    titlePanel("Shiny App for COVID-19 Dashboard"),
    
    theme = shinytheme("flatly"),
    sidebarLayout(
        sidebarPanel(
            
            p("Select countires (6 are chosen by default"),
            br(),
            
            selectInput(
                "country",
                label = "Select the countries you want for the plot!",
                multiple = TRUE,
                choices = unique(covid19()$administrative_area_level_1),
                selected = c("United States", 
                             "India", 
                             "Brazil", 
                             "Russia",
                             "United Kingdom",
                             "France")
            ),
            
            
            selectInput(
                "type",
                label = "Select the Type of cases you want to see",
                choices = c(
                    "confirmed",
                    "tests",
                    "recovered",
                    "deaths",
                    "vaccines"
                )
            ),
            
            selectInput(
                "level",
                label = "Select level - Country, Region or City",
                choices = c(
                    "Country" = 1,
                    "Region" = 2,
                    "City" = 3
                ),
                selected = 1
            ),
            
            dateRangeInput(
                "date",
                label = "Select the range of Date for the data",
                start = "2020-01-01"
            )
        ),
        
        mainPanel(
            h3("Plot"),
            plotlyOutput("covid19plot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$covid19plot <- renderPlotly({
        if (!is.null(input$country)) {
            x <- covid19(
                country = input$country,
                level = input$level,
                start = input$date[1],
                end = input$date[2]
            )
            color <- paste0("administrative_area_level_", input$level)
            plot_ly(x = x[["date"]],
                    y = x[[input$type]],
                    color = x[[color]],
                    type = 'scatter',
                    mode = 'lines')
            
        }
    })
    
}

# Run the application :-)
shinyApp(ui = ui, server = server)
