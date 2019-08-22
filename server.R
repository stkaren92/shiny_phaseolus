library(shiny)
library(shinyjs)
library(leaflet)
library(RColorBrewer)
#library(googleVis)
library(plyr)
library(tidyverse)
#library(taxize)
library(latticeExtra)
library(vegan)
library(plotly)
#library(vcd)
library(sp)
library(rgdal)
#library(deldir)
library(ggthemes)
#library(ggmap)
#library(ggvoronoi)
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
    else if (input$Habitat.1 != "All" & input$Estado != "All") {
      updateSelectInput(session, inputId = "Especie", label = "Especie:", 
                        choice = c("All" ,levels(droplevels(Mex3$Especie[Mex3$Estado %in% input$Estado &
                                                                           Mex3$Habitat.1 %in% input$Habitat.1]))))
    }
      else if (input$Habitat.1 == "All" & input$Estado != "All") {
        updateSelectInput(session, inputId = "Especie", label = "Especie:", 
                          choice = c("All" ,levels(droplevels(Mex3$Especie[Mex3$Estado %in% input$Estado]))))
      }
      else 
      {
        updateSelectInput(session, inputId = c("Estado"), label = c("Estado:"), 
                          choice = c("All", levels(Mex3$Estado[Mex3$Habitat.1 %in% input$Habitat.1])))
        updateSelectInput(session, inputId = c("Especie"), label = c("Especie:"), 
                          choice = c("All", levels(Mex3$Especie[Mex3$Habitat.1 %in% input$Habitat.1])))
      }
               )
    

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

    leaflet() %>%
      addTiles() %>%
      addProviderTiles("OpenStreetMap.BlackAndWhite") %>%
      addCircles(data = Tabla3,
                 lng = ~Longitud, lat = ~Latitud,
                 color = Tabla3$RatingCol, weight = 5, opacity = 0.7,
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
    
#    points1 <- reactive({
      #Por Estado
      
     
      
      
      
#       if (input$Estado1 != "All") {
#        Mex4 <- Mex4[Mex4$Estado %in% input$Estado1,]
#      } else Mex4 <- Mex4
      
      #Por Especie
#      if (input$Especie1 != "All") {
#        Mex4 <- Mex4[Mex4$Especie %in% input$Especie1,]
#      } else Mex4 <- Mex4
      
#
#    Mex10 <- reactive({
#      if (input$Var11 == "prom") {Mex4a <- Mex7}
#      if (input$Var11 == "maximo") {Mex4a <- Mex8}
#      else (input$Var11 == "minimo") {Mex4a <- Mex9}
#      
      #Mex6[Mex6 %in% input$var11,]
 #     })
    
    
 #   })
    
    Mex10 <- reactive({
      switch(input$var11,
             "promedio" = Mex7,
             "máximo" = Mex8,
             "mínimo" = Mex9)
    })
    
    
    
    ####
    output$graph2 <- renderPlot({
      LL <- Mex10()
      uno <- ggplot(LL) + 
        geom_dumbbell(aes(x = minimo, xend = maximo, y = reorder(Especie, ordenar1) ),
                      colour = "#dddddd",
                      size = 1,
                      colour_x = "#FAAB18",
                      colour_xend = "#1380A1",
                      dot_guide = TRUE,
                      dot_guide_size = 0.05) +
        theme_minimal() +
        theme(legend.position = "", 
              axis.text.x = element_text(angle = 0, size = 8, hjust = 1, vjust = 0),
              axis.text.y = element_text(size = 10, face = "italic"), 
              axis.title = element_text(size = 11), 
              legend.text = element_text(size = 11)) +
        labs(title = "Altitud", x = "metros", 
             y = "", fill = "",
             family = "Helvetica") +
        xlim(0, 4000)
      
      uno
      }
      )

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
