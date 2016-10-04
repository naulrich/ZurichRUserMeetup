#
# This is the basic hello world Shiny web application with only slight modifications. 
# You can run the application by clicking the 'Run App' button above.
#

library(shiny)

# ------------------------------------------------------------------------------
# User Interface
# ------------------------------------------------------------------------------

ui <- shinyUI(fluidPage(
        
        # Application title
        titlePanel("Old Faithful Geyser Data"),
        
        # Sidebar with a slider input for number of bins 
        sidebarLayout(
                sidebarPanel(
                        sliderInput("bins",
                                    "Number of bins:",
                                    min = 1,
                                    max = 50,
                                    value = 30)
                ),
                # Show a plot of the generated distribution
                mainPanel(
                        "test",
                        plotOutput("distPlot")
                )
        )
))

# ------------------------------------------------------------------------------
# Server / Calculation Logic
# ------------------------------------------------------------------------------

server <- shinyServer(function(input, output) {
        
        # you could access input$bins also directly in the renderPlot call
        # however, if you aim to use the value several times, it might be more 
        # handy for you to create a "getXY" function, as demonstrated here
        getBinNumber <- reactive({
                binNumber <- input$bins
                return(binNumber)
        })
        
        output$distPlot <- renderPlot({
                binNumber <- getBinNumber()
                
                # generate bins based on input$bins from ui.R
                x    <- faithful[, 2] 
                bins <- seq(min(x), max(x), length.out = binNumber + 1)
                
                # draw the histogram with the specified number of bins
                hist(x, breaks = bins, col = 'darkgray', border = 'white')
        })
})

# ------------------------------------------------------------------------------
# Run the application 
# ------------------------------------------------------------------------------
 
shinyApp(ui = ui, server = server)

