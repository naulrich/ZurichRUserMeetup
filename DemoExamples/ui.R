# 
# ui.R
# - sourcing libraries
# - contains all user interface related aspects as well as input & output handling
#
# in this case, I went for a rather simple structure, as there were not too
# many tabs. naturally, you could also outsource functions to your utils folder.
#

source("libraries.R")

#------------------------------------------------------------------------------
# Header / Sidebar
#------------------------------------------------------------------------------
header <- dashboardHeader(title = "Demo Dashboard")

# for icons, see https://rstudio.github.io/shinydashboard/appearance.html#icons
sidebar <- dashboardSidebar(
        sidebarMenu(id = "sidebarTabs",
                menuItem("Basic Example", tabName = "basic", icon = icon("anchor")),
                menuItem("Extended Example", tabName = "extended", icon = icon("dashboard")),
                menuItem("Map Example", tabName = "map", icon = icon("map-o"))
        )
)

#------------------------------------------------------------------------------
# Body
#------------------------------------------------------------------------------
body <- dashboardBody(
           tabItems(
                   tabItem(tabName = "basic",
                           h1("Old Faithful Geyser Data"),
                           br(),
                           sidebarLayout(sidebarPanel(
                                   sliderInput("binsFaithful", "Number of bins:",
                                               min = 1, max = 50, value = 30)
                                   ), 
                                   # Show a plot of the generated distribution
                                   mainPanel( 
                                           plotOutput("plotFaithful")
                                           )
                                   ),
                           br(),
                           br(),
                           hr(),
                           actionButton("switch", "Switch to Extended Example")
                   ),
                   tabItem(tabName = "extended",
                           h1("Extended Example"),
                           br(),
                           box(tabsetPanel(
                                   tabPanel("Upload",
                                            br(),
                                            "This tab demonstrates the fileInput widget for shiny, note that for this example it's accepting csv-formats only.",
                                            br(),
                                            "However, you could adapt to Excel, JSON, etc by adjusting the \"accept\" parameter.",
                                            hr(),
                                            
                                            fileInput("file1", "Choose Input CSV File",
                                                      accept = c(
                                                              "text/csv",
                                                              "text/comma-separated-values,text/plain",
                                                              ".csv")),
                                            tags$hr(),
                                            h2("Data Preview:"),
                                            tableOutput("previewTable")
                                            ), 
                                   tabPanel("Table", 
                                            br(),
                                            "Minimal example that uses DataTables (DT) and directly converts it from a standard data frame to this nice table input, which you can subset, filter, search within etc.",
                                            br(),
                                            hr(),
                                            br(),
                                            dataTableOutput("dataTable")
                                            ),
                                   tabPanel("Plots",
                                            br(),
                                            "This tab demonstrates a few plotting examples based on the ggplot2 library. You can either use static versions, or reactive ones.",
                                            br(),
                                            "Here, the plot takes the data from the upload Tab. If no data is loaded, we get no plot.",
                                            br(),
                                            br(),
                                            plotOutput("dataScatterplot"),
                                            br(),
                                            hr(),
                                            br(),
                                            "Direct manipulation options are also possible, based on the shiny widgets as this slider for instance:",
                                            br(),
                                            br(),
                                            sliderInput("binwidth", "Number of bins:",
                                                               min = 0.1, max = 2, value = 1),
                                            plotOutput("dataHistogram")
                                   ),
                                   tabPanel("Charts",
                                            br(),
                                            "This tab demonstrates some chart examples based on the rCharts library, a package which allows you to generate interactive javascript visualizations out of the box.",
                                            "The library is based on lattice plot (if you aim to amend the examples).",
                                            br(),
                                            "Again, the charts takes the data from the upload Tab. If no data is loaded, we get no plot. ",
                                            br(),
                                            br(),
                                            showOutput("dataScatterplotJS", "polycharts"),
                                            br(),
                                            hr(),
                                            br(),
                                            "There are various other options of nice visualizations based on rCharts, here one of my favourite ones (this time on the Hair Eye Colour dataset): ",
                                            br(),
                                            br(),
                                            showOutput("dataBarchartJS", "nvd3")
                                   ),
                                   tabPanel("Export",
                                            br(),
                                            "In this tab, you get an example of a data export, where you can download a data frame as a csv.",
                                            br(),
                                            "In general, data frames or other kind of data representations can be exported to every format handled by R writing functions.",
                                            br(),
                                            br(),
                                            downloadButton('downloadTable', 'Save data table to .csv'),
                                            br(),
                                            h2("Data Preview"),
                                            br(),
                                            tableOutput("viewbeforedownloadTable")
                                   )
                                   
                           ), width = NULL)
                   ),
                   tabItem(tabName = "map",
                           h2("Map Example with leaflet"),
                           "Example of an interactive map based on leaflet.", 
                           br(),
                           "Data source is the",
                           a("Open Data Catalogue Zurich City", href="https://data.stadt-zuerich.ch/",  target="_blank"),
                           ", in detail the data on fountains and district offices of the city as well as the buildings with an official gastro licence (state 31th of december 2015).",
                           br(),
                           br(),
                           fluidRow(
                                   column(9,
                                          box(
                                                  leafletOutput("ZHmap",
                                                                height = 800), width = NULL
                                          )),
                                   column(3,
                                          box(
                                                  h3("Change Map appearance:"),
                                                  checkboxGroupInput(inputId = "choiceMap", 
                                                      label = "Mark coordinates of..", 
                                                      choices = list("fountains" = 1, 
                                                                     "district offices" = 2, "gastro" = 3),
                                                      selected = 2),
                                                  strong("Handle Map color:"),
                                                  checkboxInput("colorMap", label = "Color", value = TRUE),
                                                  width = NULL
                                          )
                                   )
                           )
                   )
           )
)

        

ui <- shinyUI(dashboardPage(header, sidebar, body, skin = "green"))