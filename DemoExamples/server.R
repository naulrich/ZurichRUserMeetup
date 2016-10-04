# 
# server.R
# - sourcing utility functions (all .R files in "utils" folder)
# - contains all backend/calculation functions and renders output
#
# in this case, I went for a rather simple structure, as there were not too
# many tabs. naturally, you could also outsource functions to your utils folder.
#

# source all .R files in utils-Folder - a standard command.
source(paste0("utils/",list.files(path = "utils/", pattern = "\\.R$"))) 

server <- shinyServer(function(input, output, session) {
        #----------------------------------------------------------------------
        # Basic Example
        #----------------------------------------------------------------------
        output$plotFaithful <- renderPlot({
                # generate bins based on input$bins from ui.R
                waiting    <- faithful[, 2] 
                bins <- seq(min(waiting), max(waiting), length.out = input$binsFaithful + 1)
                
                # draw the histogram with the specified number of bins
                hist(waiting, breaks = bins, col = 'darkgray', border = 'white')
        })
        
        
        observeEvent(input$switch, {
                     updateTabItems(session, inputId = "sidebarTabs", "extended")
        }
        )
        
        #----------------------------------------------------------------------
        # Extended Example
        #----------------------------------------------------------------------
        
        getUploadedDataframe <- reactive({
                inFile <- input$file1
                if (is.null(inFile))
                        return(NULL)
                
                data <- read.csv(inFile$datapath, header = TRUE) %>%
                        data.frame()
                data
        })

        output$previewTable <- renderTable({
                data <- getUploadedDataframe()
                if (is.null(data)){
                        return(NULL)
                } else {
                        head(data,10)
                }
        })

        # ---------------------------------------------------------------------
        
        output$dataTable <- renderDataTable({
                data <- getUploadedDataframe()
                data
        })
            
        # ---------------------------------------------------------------------
        output$dataScatterplot <- renderPlot({
                data <- getUploadedDataframe()
                vars <- names(data)
                ggplot(data, aes(x = data[,2], y = data[,3], color = data[,6])) + 
                        geom_point(size=4, alpha = 0.4) +
                        xlab(vars[2]) +
                        ylab(vars[3]) +
                        theme_bw() +
                        theme(legend.title = element_blank()) #no legend title
                        
        })
        
        output$dataHistogram <- renderPlot({
                data <- getUploadedDataframe()
                vars <- names(data)
                ggplot(data, aes(x = data[,2])) +
                        geom_histogram(binwidth = input$binwidth) +
                        xlab(vars[2]) +       
                        theme_bw() #+facet_grid(data[,6] ~ .)
        })
        
        # ---------------------------------------------------------------------
        
        output$dataScatterplotJS <- renderChart({
                data <- getUploadedDataframe()
                names(data) = gsub("\\.", "", names(data))
                vars <- names(data)
                
                p1 <- rPlot(vars[2], vars[3], data = data, color = vars[length(vars)], #facet = vars[length(vars)],
                            type = 'point') 
                            
                p1$addParams(dom = 'dataScatterplotJS')
                return(p1)
        })
        
        output$dataBarchartJS <- renderChart({
                hair_eye = as.data.frame(HairEyeColor)
                p6 <- nPlot(Freq ~ Hair, group = 'Eye', data = subset(hair_eye, Sex == "Male"), 
                            type = 'multiBarChart')
                p6$chart(color = c('red', 'blue', '#594c26', 'green'), stacked = FALSE)
                p6$addParams(dom = 'dataBarchartJS')
                return(p6)
        })

  
        # ---------------------------------------------------------------------
        
        output$downloadTable <- downloadHandler(  
                filename = "downloadedData.csv",
                content = function(file){
                        data <- getUploadedDataframe()
                        write.csv(data,file)
                }
        )
        
        output$viewbeforedownloadTable <- renderTable({
                data <- getUploadedDataframe()
                data
        })
        

        

        # ---------------------------------------------------------------------
        getMapChoice <- reactive({
                if(is.null(input$choiceMap)){
                        return(NULL)
                } else {
                        mapchoices <- list()
                        i <- 1
                        if (1 %in% input$choiceMap) {
                                mapchoices[i] <- "fountains"  
                                i <- i + 1
                        } 
                        if (2 %in% input$choiceMap) {
                                mapchoices[i] <- "district offices"
                                i <- i + 1
                        }
                        if (3 %in% input$choiceMap){
                                mapchoices[i] <- "gastro"
                        }
                        return(mapchoices)
                }
        })
        
        output$ZHmap <- renderLeaflet({
                mapchoices <- getMapChoice()
                
                map <- leaflet() %>% setView(lat = 47.3769, lng = 8.5417, zoom = 13) %>%
                        addTiles()
                if(input$colorMap == FALSE){
                        map <- addProviderTiles(map, "CartoDB.Positron")
                }
                
                if ("fountains" %in% mapchoices) {
                        map <- map %>%
                                addCircles(lat = fountains$Latitude,
                                           lng = fountains$Longitude, weight = 1, radius = 50,
                                           color = "red")
                }
                if ("district offices" %in% mapchoices) {
                        map <- map %>%
                                addCircles(lat = districtOffices$Latitude,
                                           lng = districtOffices$Longitude,
                                           weight = 2, radius = 100, color = "blue")
                }
                if ("gastro" %in% mapchoices) {
                        map <- map %>%
                                addCircles(lat = gastro$Latitude,
                                           lng = gastro$Longitude,
                                           weight = 1, radius = 50, color = "green")
                }
                
                colorFrame <- data.frame(colors = c("red", "blue", "green"),
                                         choices = c("fountains" , "district offices","gastro")) %>%
                              filter(choices %in% mapchoices)
                
                map <- map %>%
                        addLegend(colors = colorFrame$colors, 
                                  labels = colorFrame$choices)
                
                map    
                
        })
})