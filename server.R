library(shiny)
library(shinyjs)
library(leaflet)
library(RColorBrewer)
library(plyr)
library(tidyverse)
library(latticeExtra)
library(vegan)
library(plotly)
library(sp)
# library(rgdal)
library(ggthemes)
library(waffle)
#library(gganimate)

# Define server logic for slider examples
shinyServer(
  function(input, output, session) {
    
    #Hacer interactivo el mapa
    shinyjs::onclick("mapa", 
                     shiny::updateNavbarPage(session, 
                                              inputId = "navbar",
                                              selected = "widgets"))
    
    #Hacer interactivo la altitud
    shinyjs::onclick("altitud", 
                     shiny::updateNavbarPage(session, 
                                             inputId = "navbar",
                                             selected = "widgets1"))
    
    #Hacer interactivo florecimiento
    shinyjs::onclick("crecimiento", 
                     shiny::updateNavbarPage(session, 
                                             inputId = "navbar",
                                             selected = "widgets3"))
    
    #Hacer interactivo waffle plot
    shinyjs::onclick("waffle", 
                     shiny::updateNavbarPage(session, 
                                             inputId = "navbar",
                                             selected = "widgets2"))
    
    
    output$inc <- renderUI({getPage()})
    

    
    observeEvent(
      eventExpr =  c(input$Habitat.1, input$Estado, input$Especie, baseGroups1),  
      if (input$Habitat.1 != "All" & input$Estado != "All" & input$Especie != "All") {
        
        selectInput(session, inputId = "Estado", 
                          #label = "Estado:", 
                          choices = c("All", levels(Mex3$Estado)))
        selectInput(session, inputId = "Especie", 
                          #label = "Especie:", 
                          choices = c("All", levels(Mex3$Especie)))
        selectInput(session, inputId = "Habitat.1", 
                          #label = "Especie:", 
                          choices = c("All", levels(Mex3$Habitat.1)))
        
        
       # updateSelectInput(session, inputId = "Estado", 
       #                   #label = "Estado:", 
       #                   choices = c("All", levels(Mex3$Estado[Mex3$Habitat.1 %in% input$Habitat.1 &
       #                                                                      Mex3$Especie %in% input$Especie])))
       # updateSelectInput(session, inputId = "Especie", 
       #                   #label = "Especie:", 
       #                   choices = c("All", levels(Mex3$Especie[Mex3$Habitat.1 %in% input$Habitat.1 &
       #                                                                       Mex3$Estado %in% input$Estado])))
       # updateSelectInput(session, inputId = "Habitat.1", 
       #                   #label = "Especie:", 
       #                   choices = c("All", levels(Mex3$Habitat.1[Mex3$Especie %in% input$Especie &
       #                                                                         Mex3$Estado %in% input$Estado])))
        
      }  
       else if (input$Habitat.1 != "All" & input$Estado != "All" & input$Especie == "All") {
        
        updateSelectInput(session, inputId = "Especie", 
                          #label = "Especie:", 
                          choices = c("All" ,levels(droplevels(Mex3$Especie[Mex3$Estado %in% input$Estado &
                                                                              Mex3$Habitat.1 %in% input$Habitat.1]))))
      }
      else if (input$Habitat.1 != "All" & input$Estado == "All" & input$Especie == "All") {
        
         updateSelectInput(session, inputId = "Estado", 
                           #label = "Especie:", 
                           choices = c("All" ,levels(droplevels(Mex3$Estado[Mex3$Habitat.1 %in% input$Habitat.1]))))
        updateSelectInput(session, inputId = "Especie", 
                          #label = "Especie:", 
                          choices = c("All" ,levels(droplevels(Mex3$Especie[Mex3$Habitat.1 %in% input$Habitat.1]))))
        #baseGroups1 = baseGroups1[2]
      }
      else if (input$Habitat.1 == "All" & input$Estado != "All" & input$Especie != "All") {
   
        updateSelectInput(session, inputId = "Habitat.1", 
                          #label = "Especie:", 
                          choices = c("All" ,levels(droplevels(Mex3$Habitat.1[Mex3$Estado %in% input$Estado &
                                                                                Mex3$Especie %in% input$Especie]))))
      }
      else if (input$Habitat.1 == "All" & input$Estado != "All" & input$Especie == "All") {
        updateSelectInput(session, inputId = "Especie", 
                          #label = "Especie:", 
                          choices = c("All" ,levels(droplevels(Mex3$Especie[Mex3$Estado %in% input$Estado]))))
        
        updateSelectInput(session, inputId = "Habitat.1", 
                          #label = "Especie:", 
                          choices = c("All" ,levels(droplevels(Mex3$Habitat.1[Mex3$Estado %in% input$Estado]))))
      }
      else if (input$Habitat.1 == "All" & input$Estado == "All" & input$Especie != "All") {
        updateSelectInput(session, inputId = "Estado", 
                          #label = "Especie:", 
                          choices = c("All" ,levels(droplevels(Mex3$Estado[Mex3$Especie %in% input$Especie]))))
        
        updateSelectInput(session, inputId = "Habitat.1", 
                          #label = "Especie:", 
                          choices = c("All" ,levels(droplevels(Mex3$Habitat.1[Mex3$Especie %in% input$Especie]))))
      }
      else if (input$Habitat.1 != "All" & input$Estado == "All" & input$Especie != "All") {
        updateSelectInput(session, inputId = "Estado", 
                          #label = "Especie:", 
                          choices = c("All" ,levels(droplevels(Mex3$Estado[Mex3$Especie %in% input$Especie &
                                                                             Mex3$Habitat.1 %in% input$Habitat.1]))))
      }
      else 
      {
        selectInput(session, inputId = "Estado", 
                          #label = "Estado:", 
                          choices = c("All", levels(Mex3$Estado)))
        selectInput(session, inputId = "Especie", 
                          #label = "Especie:", 
                          choices = c("All", levels(Mex3$Especie)))
        selectInput(session, inputId = "Habitat.1", 
                          #label = "Especie:", 
                          choices = c("All", levels(Mex3$Habitat.1)))
      }
    )
    
     
    #Para el mapa
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
    
    
 #   map = leaflet()
 #   for (i in 1:length(providers)) {
 #     map = map %>% addProviderTiles(providers[i], group = providers[i])
 #   }
 #   
 #   map = map %>% addLayersControl(
 #     baseGroups = providers,
 #     options = layersControlOptions(collapsed = FALSE))
    
 #   map
    baseGroups1 = c("OSM (default)", "CartoDB Dark", "Open Street France")
    
    output$mymap1 <- renderLeaflet(
      {
       # providers <- c("Stamen.TonerLite", "Esri.WorldTopoMap", 
        #               "CartoDB.Positron", "Acetate.terrain")
        Tabla3 <- points()
        leaflet() %>%
        addTiles() %>%
          #providerTileOptions(updateWhenIdle = FALSE) %>% 
          addCircles(data = Tabla3, group = "Circles",
                     lng = ~Longitud, lat = ~Latitud,
                     color = Tabla3$RatingCol, weight = 5, opacity = 0.7,
                     popup = ~paste(sep = " ", "Especie:",Tabla3$Taxa,
                                    "<br/>", "Condición:",Tabla3$Habitat.1,
                                    "<br/>", "Estado:",Tabla3$Estado,
                                    "<br/>", "Municipio:",Tabla3$Municipio,
                                    "<br/>", "Localidad:",Tabla3$Localidad,
                                    "<br/>", "Altitud:",Tabla3$Altitud, "metros",
                                    "<br/>", "Año de colecta:", Tabla3$AnioColecta,
                                    "<br/>", "<br/>", "NA, ND, 9999 = no hay dato")) %>% 
        addLayersControl(
        #baseGroups = c("OSM (default)"),
        baseGroups = baseGroups1,
        position = c("topleft"),
        options = layersControlOptions(collapsed = FALSE)) %>% 
      #addProviderTiles("CartoDB.DarkMatter", group = "CartoDB Dark") %>%
      addProviderTiles("CartoDB.DarkMatter", group = "CartoDB Dark", options = layersControlOptions(autoZIndex = FALSE)) %>%
      addProviderTiles("OpenStreetMap.France", group = "Open Street France", options = layersControlOptions( autoZIndex = FALSE))
      })
 
  #Para la Floración    
    observeEvent(
      input$Estado1,
        updateSelectInput(session, inputId = "Especie1", label = "Especie:", 
                          choice = c("All" ,levels(droplevels(Mex4$Especie[Mex4$Estado %in% input$Estado1])))))
    
    #Para las epocas de lluvia y Floración
    points1 <- reactive({
      #Epoca
      FloFru <- FloFru[FloFru$Epoca %in% input$Epoca,]
      #Tipo
      FloFru <- FloFru[FloFru$Tipo %in% input$Tipo,]
    })
    

output$graph4 <- renderPlot({
  
  FloFru1 <- points1() %>%
    gather("Mes", "Val", 8:19) %>%
    rename("Categoria" = "NombreCategoriaTaxonomica") %>% 
    rename("Genero1" = "Nombre_1_Nombre") %>% 
    rename("Especie1" = "Nombre_Nombre") %>% 
    group_by(Genero1, Especie1, Mes) %>% 
    summarise(sum(Val)) %>% 
    rename(Val = `sum(Val)`) %>% 
    unite(Genero1, Especie1, col = "Especie", sep = " ")
  
  FloFru1$Mes <- as.factor(FloFru1$Mes)
  
  FloFru1$Mes <- ordered(FloFru1$Mes, levels = c("Enero", "Febrero", "Marzo",
                                                 "Abril", "Mayo", "Junio",
                                                 "Julio", "Agosto", "Septiembre",
                                                 "Octubre", "Noviembre", "Diciembre"))
  
  
  p <- ggplot(FloFru1, aes(Mes, Especie)) + 
    geom_tile(aes(fill = Val), colour = "white") + 
    scale_fill_gradient(low = "#deebf7", high = "#3182bd") +
    theme_minimal() +
    theme(panel.border = element_blank(),
          axis.text.y = element_text(size = 12, face = "italic"),
          axis.text.x = element_text(angle = 45, size = 12, hjust = 0.2, vjust = 0.2),
          legend.position = "")
  
  p
  
  
})    
    
  #Para la Altitud  
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
                      size = 3,
                      colour_x = "#FAAB18",
                      colour_xend = "#1380A1",
                      dot_guide = TRUE,
                      dot_guide_size = 0.05) +
        theme_minimal() +
        theme(legend.position = "", 
              axis.text.x = element_text(angle = 0, size = 8, hjust = 1, vjust = 0),
              axis.text.y = element_text(size = 12, face = "italic"), 
              axis.title = element_text(size = 11), 
              legend.text = element_text(size = 11)) +
        labs(title = "Altitud", x = "metros", 
             y = "", fill = "",
             family = "Helvetica") +
        xlim(0, 4000) 
     # last_plot +
    #    transition_reveal(ordenar1)
      
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
        ggtitle(label =  "Proporción de especies de frijol",
                subtitle = "(Nota: Basado en el número de registros de cada especie por estado)") +
         scale_fill_manual(values = mypalette, name = "Especies", labels = TTabla1$Especie) +
        #labs(title = "Proporción de especies de frijol\n(Nota: Basado en el número de registros de cada especie por estado)") +
        guides(fill = guide_legend(title.theme = element_text(size = 20))) +
        theme(legend.text = element_text(size = 15, face = "italic"),
              legend.key.size = unit(0.9, "cm"),
              plot.title = element_text(size = 16, face = "bold"),
              plot.subtitle = element_text(color = "#525252"))
        
    #  theme(
    #    plot.title = element_text(color = "red", size = 12, face = "bold"),
    #    plot.subtitle = element_text(color = "blue"),
    #    plot.caption = element_text(color = "green", face = "italic")
      
      
      print(dos)
    
    })
  
  } # end server
)
