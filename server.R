library(shiny)
library(shinyjs)
library(leaflet)
library(RColorBrewer)
#library(googleVis)
library(tidyverse)
#library(taxize)
library(plyr)
library(latticeExtra)
library(vegan)
library(plotly)
#library(vcd)
library(sp)
library(rgdal)
library(deldir)
library(ggthemes)
library(ggmap)
library(ggvoronoi)
library(waffle)

# Define server logic for slider examples
shinyServer(
  function(input, output, session) {
    
    
    output$inc <- renderUI({getPage()})
    
    
    
  
    
    observeEvent(
      eventExpr =  c(input$Habitat.1, input$Estado),  if (input$Habitat.1 != "All" & input$Estado == "All") {
        updateSelectInput(session, inputId = c("Estado"), label = c("Estado:"), 
                          choice = c("All", levels(droplevels(Mex3$Estado[Mex3$Habitat.1 %in% input$Habitat.1]))))
        updateSelectInput(session, inputId = c("Especie"), label = c("Especie:"), 
                          choice = c("All", levels(droplevels(Mex3$Especie[Mex3$Habitat.1 %in% input$Habitat.1]))))
        
      }  
      #else if (input$Habitat.1 != "All") {
      #  updateSelectInput(session, inputId = c("Estado"), label = c("Estado:"), 
      #                    choice = c("All", levels(droplevels(Mex3$Estado[Mex3$Habitat.1 %in% input$Habitat.1]))))
      #} 
    #  else if (input$Estado != "All") {
    #    updateSelectInput(session, inputId = c("Especie"), label = c("Especie:"), 
    #                      choice = c("All", levels(droplevels(Mex3$Especie[Mex3$Estado %in% input$Estado]))))
    #  }
    else if (input$Habitat.1 != "All" & input$Estado != "All") {
      updateSelectInput(session, inputId = "Especie", label = "Especie:", 
                        choice = c("All" ,levels(droplevels(Mex3$Especie[Mex3$Estado %in% input$Estado &
                                                                           Mex3$Habitat.1 %in% input$Habitat.1]))))
      # toggle("hideme") 
    }
      else if (input$Habitat.1 == "All" & input$Estado != "All") {
      #  updateSelectInput(session, inputId = c("Habitat.1"), label = c("Habitat:"), 
      #                     choice = c("All", levels(Mex3$Habitat.1)))
        updateSelectInput(session, inputId = "Especie", label = "Especie:", 
                          choice = c("All" ,levels(droplevels(Mex3$Especie[Mex3$Estado %in% input$Estado]))))
        # toggle("hideme") 
      }
      else 
      {
        #updateSelectInput(session, inputId = c("Especie", "Habitat.1", "Estado"))
        updateSelectInput(session, inputId = c("Estado"), label = c("Estado:"), 
                          choice = c("All", levels(Mex3$Estado[Mex3$Habitat.1 %in% input$Habitat.1])))
        updateSelectInput(session, inputId = c("Especie"), label = c("Especie:"), 
                          choice = c("All", levels(Mex3$Especie[Mex3$Habitat.1 %in% input$Habitat.1])))
      }
               )
    
#    observeEvent(
#     input$Habitat.1,  if (input$Habitat.1 != "All") {
#        updateSelectInput(session, inputId = "Especie", label = "Especie:", 
#                          choice = c("All", levels(droplevels(Mex3$Especie[Mex3$Habitat.1 %in% input$Habitat.1]))))
#        # toggle("hideme") 
#      } else updateSelectInput(session, inputId = "Especie", label = "Especie:", 
#             choice = c("All", levels(Mex3$Especie[Mex3$Habitat.1 %in% input$Habitat.1] & Mex3$Estado[Mex3$Habitat.1 %in% input$Habitat.1]))))

  #  observeEvent(
  #    input$Estado,  if (input$Habitat.1 == "All" & input$Estado != "All") {
  #      updateSelectInput(session, inputId = "Especie", label = "Especie:", 
  #                        choice = c("All" ,levels(droplevels(Mex3$Especie[Mex3$Estado %in% input$Estado]))))
  #     # toggle("hideme") 
  #    } else updateSelectInput(session, inputId = "Especie", label = "Especie:", 
  #                             choice = c("All", levels(droplevels(Mex3$Especie[Mex3$Estado %in% input$Estado])))))
      
    
    
    
  #  observeEvent(
  #    input$Estado, {
  #      toggle("hideme")    
  #    }
  #  )
    
    points <- reactive({
      
      #Tipo
      if (input$Habitat.1 != "All") {
        Mex3 <- Mex3[Mex3$Habitat.1 %in% input$Habitat.1,]
      } else Mex3 <- Mex3
      
  
              #Por Estado
        if (input$Estado != "All") {
          Mex3 <- Mex3[Mex3$Estado %in% input$Estado,]
        } else Mex3 <- Mex3
      
        #Por Especie
        if (input$Especie != "All") {
          Mex3 <- Mex3[Mex3$Especie %in% input$Especie,]
        } else Mex3 <- Mex3

    })
    
    output$mymap1 <- renderLeaflet(
      {
    Tabla3 <- points()
    #Tabla3 <- Mex3
   # head(Tabla3)
    
    
    #Para los diagramas de Voronoi
  #  Tabla4 <- Tabla3 %>%
    #  distinct(Longitud, Latitud) %>%
    #  na.omit(Longitud)
    
    
  #  vor_pts <- SpatialPointsDataFrame(cbind(Tabla4$Longitud, Tabla4$Latitud),
  #                                    Tabla4, match.ID = T)
  #  vor <- SPointsDF_to_voronoi_SPolysDF(vor_pts)
    #class(vor)
    
    leaflet() %>%
      addTiles() %>%
      # base map
      
      #droplevels(TablaH$Estado)
      
      #addProviderTiles("Hydda.Base") %>%
      addProviderTiles("OpenStreetMap.BlackAndWhite") %>%
      
      #  #Para el diagrama de Voronoi
   #   addPolygons(data = vor,
  #                stroke = TRUE, color = "#a5a5a5", weight = 0.25,
   #               fill = TRUE, fillOpacity = 0.0,
  #                smoothFactor = 0.5) %>%
      # puntos de Frijol
      addCircles(data = Tabla3,
                 lng = ~Longitud, lat = ~Latitud,
                 #radius = ~sqrt(Plantíos)*300, # size is in m for addCircles O_o
                 #color = ~factpal(Cultivo), weight = 1, opacity = 1,
                 color = Tabla3$RatingCol, weight = 5, opacity = 0.7,
                 #fillColor = ~factpal(Cultivo), fillOpacity = 0.5,
                 popup = ~paste(sep = " ", "Especie:",Tabla3$Taxa,
                                "<br/>", "Condición:",Tabla3$Habitat.1,
                                "<br/>", "Estado:",Tabla3$Estado,
                                "<br/>", "Municipio:",Tabla3$Municipio,
                                "<br/>", "Localidad:",Tabla3$Localidad,
                                "<br/>", "Altitud:",Tabla3$Altitud,
                                "<br/>", "Año de colecta:", Tabla3$AnioColecta))
    
     })
    
    
    observeEvent(
      input$Estado1,
        updateSelectInput(session, inputId = "Especie1", label = "Especie:", 
                          choice = c("All" ,levels(droplevels(Mex4$Especie[Mex4$Estado %in% input$Estado1])))))
    
    points1 <- reactive({
      #Por Estado
      
      if (input$Estado1 != "All") {
        Mex4 <- Mex4[Mex4$Estado %in% input$Estado1,]
      } else Mex4 <- Mex4
      
      #Por Especie
      if (input$Especie1 != "All") {
        Mex4 <- Mex4[Mex4$Especie %in% input$Especie1,]
      } else Mex4 <- Mex4
      
      
    })
  
    ####
#    output$graph2 <- renderPlot({
      
#      Tabla3a <- points1()
#      Tabla4.1 <- Tabla3a %>%
#        distinct(Longitud, Latitud, .keep_all = T)
#        
#      TT <- as.character(droplevels(Tabla4.1$Estado)[1])
#      
#      #na.omit(Longitud)
#      
#      shapefile_df2 <- shapefile_df %>%
#        #droplevels(Estado) %>%
#         filter(group == TT)
#      
#      
#      cali.voronoi <- voronoi_polygon(data = Tabla4.1,
#                                      x = "Longitud", y = "Latitud",
#                                      outline = shapefile_df2)
#      cali.voronoi <- fortify_voronoi(cali.voronoi)
#      
#      vtess <- deldir(Tabla4.1[,14:13])
#      #summary(vtess$summary)
#      vtess1 <-  as.data.frame(vtess$summary$dir.area)
#      names(vtess1) <- c("Area")
#      vtess1$Area1 <- decostand(vtess1$Area, "log")
#      #vtess1$Area1 <- decostand(vtess1$Area1, "freq")
#      
#      Tabla4.2 <- data.frame(Tabla4.1, vtess1)
#      
#     # head(Tabla4.2)
#      
#      ggWatershed <- ggplot() +
#        geom_polygon(data = shapefile_df2, aes(x = long, y = lat, group = group), color = "black") + 
#        #geom_path(color = "black") +
#        #scale_fill_hue(l = 40) +
#        coord_equal() +
#        theme_void(base_family = "Roboto Condensed") +
#        theme(legend.position = "none", title = element_blank(), axis.text = element_blank()) + 
#        geom_voronoi(data = Tabla4.2, aes(x = Longitud, y = Latitud, fill = Area1), outline = shapefile_df2 ) +
#        scale_fill_gradient2(low = "red",high = "#eaecee", guide = F, mid = "white", midpoint = quantile(Tabla4.2$Area1, 0.75) ) +
#        geom_point(data = Tabla4.1, aes(x = Longitud, y = Latitud), size = 0, color = "steelblue")
#      
#      
#      print(ggWatershed)
#      
#    })
#    
    points2 <- reactive({
      #input$update
      
      #Por Estado
      
      if (input$Estado2 != "All") {
        Mex3 <- Mex3[Mex3$Estado %in% input$Estado2,]
      } else Mex3 <- Mex3
      
    })
    
    output$graph3 <- renderPlot({
      
      Tabla6a <- points2()
      
      Tabla6b <- Tabla6a %>%
        dplyr::select(Especie, RatingCol)
      #head(Tabla6a)
      Tabla6 <- aggregate(Tabla6a$val, by = list(Tabla6a$Especie), FUN = sum, na.rm = T)
      #head(Tabla6)
      names(Tabla6) <- c("Especie", "val")
      
      Tabla7 <- inner_join(Tabla6, Tabla6b, by = "Especie") %>%
        distinct()
      
      TTabla1 <- Tabla7 %>%
        plyr::arrange(-val) %>%
        #  filter(Estado == "Oaxaca") %>%
        mutate(val1 = ceiling(100*(val/sum(val * 1.05)))) %>%
        select(Especie, val1, RatingCol) %>%
        droplevels()
      
      Diff <- 100 - sum(TTabla1$val1)
      TTabla1$val1[1] <- TTabla1$val1[1] + Diff
      
      
      mypalette <- levels(TTabla1$RatingCol)
       uno <- waffle(TTabla1$val1, rows = 10, size = 0.3, flip = F , reverse = F, colors = mypalette, legend_pos = "right", keep = T) 
      dos <- uno + 
         theme(legend.text = element_text(size = 15),
               legend.key.size = unit(0.8, "cm")) +
         scale_fill_manual(values = mypalette, name = "Especies", labels = TTabla1$Especie) +
        labs(title = "Proporción de especies de frijol") 
        
      
      print(dos)
    
    })
  
  } # end server
)
