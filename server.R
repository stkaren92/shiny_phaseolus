library(shiny)
library(leaflet)
library(RColorBrewer)
library(knitr)
library(vcd)
library(grid)
library(plotly)
#library(googleVis)
library(igraph)
library(tidyverse)

# Define server logic for slider examples
shinyServer(
  function(input, output, session) {
    
   # observeEvent(
  #    input$Cultivo,
   #   updateSelectInput(session, "Estado", "Estado:", 
  #                      choices = c("All", levels(droplevels(TablaFF$Estado[TablaFF$Cultivo %in% input$Cultivo]))))
  #  )
    #observeEvent(
    #  input$Año,
    #  updateSelectInput(session, "Estado", "Estado:", 
    #                    choices = c("All", levels(droplevels(TablaFF$Estado[TablaFF$Año %in% input$Año]))))
#    )
    
    points <- reactive({
      #input$update
      #Tabla2 <- Tabla2()
      
     # if (input$Año != "All") {
        TablaFF <- TablaFF[TablaFF$Año %in% input$Año,]
    #  } else TablaFF <- TablaFF
      
      #TablaFF <- TablaFF[c(Tabla2$Age >= input$Age[1] & Tabla2$Age <= input$Age[2]),]
      
     # if (input$Cultivo != "All") {
        TablaFF <- TablaFF[TablaFF$Cultivo %in% input$Cultivo,]
      #}else TablaFF <- TablaFF
      
        #Para plantíos
        TablaFF <- TablaFF[TablaFF$Plantíos > input$Plantíos,]
        
        #Por Estado
        if (input$Estado != "All") {
          TablaFF <- TablaFF[TablaFF$Estado %in% input$Estado,]
        } else TablaFF <- TablaFF
      
    })
    
    
    
    output$mymap1 <- renderLeaflet(
      {
        
        #Goldberg <- points()
        TablaH <- points()
        TablaH$Region <- as.character(TablaH$Region)
        #TablaH$Estado <- as.factor(TablaH$Estado)
        droplevels(TablaH$Estado)
        #Tabla3 <- dplyr::left_join(TablaH, Mex1, by = "Region") %>%
          
         # filter(Plantíos >= 20)
        Tabla3 <- TablaH %>%
          na.omit(lng)
        
        vor_pts <- SpatialPointsDataFrame(cbind(Tabla3$lng,
                                                Tabla3$lat),
                                          Tabla3, match.ID = TRUE)
        
        vor <- SPointsDF_to_voronoi_SPolysDF(vor_pts)
        factpal <- colorFactor(c("orange", "steelblue"), Tabla3$Cultivo)
        
       # binpal <- colorBin("Blues", levels(Tabla3$Cultivo), 2, pretty = FALSE)
        
        leaflet() %>%
          addTiles() %>%
          # base map
          #addProviderTiles("Hydda.Base") %>%
          addProviderTiles("CartoDB.Positron") %>%
  #        addPolygons(data = muns,
  #                    stroke = TRUE, color = "green", weight = 0.5, opacity = 0.1,
  #                    fill = F, fillColor = "#cccccc", smoothFactor = 0.5) %>%
          # voronoi (click) layer
          addPolygons(data = vor,
                      stroke = TRUE, color = "#a5a5a5", weight = 0.25,
                      fill = TRUE, fillOpacity = 0.0,
                      smoothFactor = 0.5) %>%
          # airports layer
          addCircles(data = Tabla3,
                     lng = ~lng, lat = ~lat,
                     radius = ~sqrt(Plantíos)*300, # size is in m for addCircles O_o
                     color = ~factpal(Cultivo), weight = 1, opacity = 1,
                     #color = "steelblue", weight = 1, opacity = 1,
                     fillColor = ~factpal(Cultivo), fillOpacity = 0.5,
                     popup = ~paste(sep = " ", "ID INEGI:",Tabla3$Region,
                                    "<br/>","Estado:",Tabla3$Estado,
                                    "<br/>","Municipio:",Tabla3$NOM_MUN,
                                    "<br/>","Altitud:",Tabla3$ALTITUD,
                                    "<br/>","Plantíos:", Tabla3$Plantíos,
                                    "<br/>","Hectáreas:", Tabla3$Hectáreas))
        
      })
    
  } # end server
)
