library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyjs)
library(tidyverse)
library(markdown)
library(leaflet)
library(plotly)
library(httr)
# library(rgdal)
library(tableHTML)


dashboardPage(
  skin = "yellow",
  
  ## Dashboard Header
  dashboardHeader(
    title = "Frijol",
    titleWidth = 200,
    fixed = TRUE
  ), # close dashboard header
  
  ## Sidebar Menu
  dashboardSidebar(
    width = 200,
    shinyjs::useShinyjs(),
    collapsed = F,
    disable = F,
    sidebarMenu(
      id = "navbar",
      #shinyjs::useShinyjs(),
      menuItem("Introducción", tabName = "home", icon = icon("home")),
      menuItem("Distribución", tabName = "widgets", icon = icon("map")),
      menuItem(
        "Altitud",
        tabName = "widgets1",
        icon = icon("certificate")
      ),
      menuItem(
        "Floración y fructificación",
        tabName = "widgets3",
        icon = icon("adjust")
      ),
      menuItem("Gráfica de waffle", tabName = "widgets2", icon = icon("th")),
      menuItem("Autores", tabName = "conabio", icon = icon("user"))
    )
  ),
  # close sidebar menu
  
  ## Dashboard Body
  dashboardBody(
    #tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "style.css")),
    
    ## Tab Items Pages
    tabItems(
      ## Home
      tabItem(
        tabName = "home",
        br(),
        br(),
        div(img(image = "Conabio_horizontal_rgb.png", width = "300"), style = "text-align: center;"),
        fluidRow(
          h2(
            "Proyecto:",
            tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=JE&Numero=14",
                   strong("El género"), strong(
                     em("Phaseolus (Leguminosae, Papilionoideae, Phaseoleae)")
                   ) , strong("para México")),
            align = "center"

          ),
#####
          br(),
          h2(strong("Introducción"), align = "center"),
          h4(
            "Los frijoles (",
            em("Phaseolus sp."),
            ") pertenecen a la familia de las
leguminosas (Leguminosae o Fabaceae), junto con los chícharos, habas, soya, mezquites, huizaches
con más de  19,000 especies. En el mundo se conocen alrededor de 150 cultivares de frijoles (Visita la página de la",
            tags$a(href = "https://www.biodiversidad.gob.mx/usos/alimentacion/frijol.html", "Conabio"),
            ")."
          ),

          h4(
            "En América, el género",
            em(" Phaseolus"),
            "se distribuyen desde el sur de Canadá hasta
    el norte  de  Argentina. Existen alrededor de 70 especies, de las cuales cinco han sido domesticadas:",
            tags$a(href = "http://enciclovida.mx/especies/185375-phaseolus-acutifolius", em("Phaseolus acutifolius")),
            "A. Gray (teparí o escumite),",
            tags$a(href = "http://enciclovida.mx/especies/185948-phaseolus-coccineus", em("Phaseolus coccineus")),
            "L. (ayocote, tecomarí, botil),",
            tags$a(href = "http://enciclovida.mx/especies/186197-phaseolus-dumosus", em("Phaseolus dumosus")),
            "Macfadyen (gordo, acalete),",
            tags$a(href = "http://enciclovida.mx/especies/187118-phaseolus-lunatus", em("Phaseolus lunatus")),
            "L. (ib, comba, patachete, navajita, lima) y",
            tags$a(href = "http://enciclovida.mx/especies/188894-phaseolus-vulgaris", em("Phaseolus vulgaris")),
            "L. (cimatl, frejol, frijol, etc.) y todas pueden cohabitar con sus
    poblaciones silvestres (Delgado-Salinas et al., 2006)."
          ),

          br(),
          h2(strong("Visualización:"), align = "center"),

          fluidRow(
            box(
              title = strong("Distribución"),
              closable = FALSE,
              width = 6,
              status = "warning",
              solidHeader = FALSE,
              collapsible = TRUE,
              h4(
                "Visualiza todos los registros de ",
                em("Phaseolus"),
                "con coordinadas
           geográficas del proyecto. Los valores pueden filtrarse por las variables condición,
              estado y especie."
              ),
              userPostMedia(image = "MapDistribution1.png"),
              id = "mapa",
              style = "cursor:pointer;"
            ),

            box(
              title = strong("Altitud"),
              closable = FALSE,
              width = 6,
              status = "warning",
              solidHeader = FALSE,
              collapsible = TRUE,
              h4(
                "¿La altitud afecta al firjol? El género",
                em("Phaseolus"),
                "puede
           crecer desde el nivel del mar hasta arriba de los tres mil metros.
           Esto ha permitido que se pueda establecer en distintos ecosistemas
           de nuestro país. La gráfica muestra esa gran adaptabilidad del
           frijol."
              ),
              userPostMedia(image = "Altitud1.png"),
              id = "altitud",
              style = "cursor:pointer;"
            ),

            box(
              title = strong("Epoca de Crecimiento y Floración"),
              closable = FALSE,
              width = 6,
              status = "warning",
              solidHeader = FALSE,
              collapsible = TRUE,
              h4(
                "¿Cuándo crece y cuándo florece? El frijol esta en todo México
              y ¿todo el tiempo?, no todas las especies, pero el frijol nos
              acompaña todo el tiempo y en todos lados."
              ),
              userPostMedia(image = "Crecimiento1.png"),
              id = "crecimiento",
              style = "cursor:pointer;"
            ),

            box(
              title = strong("Gráfica de Waffle"),
              closable = FALSE,
              width = 6,
              status = "warning",
              solidHeader = FALSE,
              collapsible = TRUE,
              h4(
                "¿Cuál es la proporción de frijoles que hay en cada estado? Con
              la gráfica de waffle se puede observar de forma rápida la proporción
              de estos, ya que tiene 10 renglones x 10 columnas, es decir
              100 cuadros que representan 100% de los registros de las especies
              por cada estado"
              ),
              userPostMedia(image = "WafflePlot.png"),
              id = "waffle",
              style = "cursor:pointer;"
            )
          )
#####
        ) #close fluidRow
      ), # close home tab
      
 #####     
      ## Para el mapa 1
      tabItem(
        tabName = "widgets",
        value = "distribucion_1",
        br(),
        fluidRow(
          tags$style("#mymap1 {height: calc(100vh - 80px) !important;}"),
          leafletOutput('mymap1')
        ),
        absolutePanel(
          id = "controls",
          bottom = 250,
          left = 220,
          draggable = T,
          fixed = F,
          style = "z-index:100;",
          class = "panel-default",
          #Seleccionar el estado
          selectInput(
            inputId = "Habitat.1",
            label = h6(id = "uno1", strong("Condición:")),
            c("All", levels(Mex3$Habitat.1)),
            width = 200
          ),

          tags$style(make_css(list(
            '#uno1',
            c('color'), c('#e74c3c')
          ))),

          #Seleccionar el estado
          selectInput(
            inputId = "Estado",
            label = h6(id = 'uno2', strong("Estado:")),
            c("All", levels(Mex3$Estado)),
            width = 200
          ),

          tags$style(make_css(list(
            '#uno2',
            c('color'), c('#e74c3c')
          ))),

          #Seleccionar la especie
          selectInput(
            inputId = "Especie",
            label = h6(id = "uno3", strong("Especie:")),
            c("All", levels(Mex3$Especie)),
            width = 200
          ),

          #Change color
          tags$style(make_css(list(
            '#uno3',
            c('color'), c('#e74c3c')
          )))

        ) # close absolute panel
      ), # close tabItem widget page
#####
      ## Para la gráfica de la Altitud
      tabItem(
        tabName = "widgets1",
        br(),
        fluidRow(
          tags$style(type = "text/css", "#graph2 {height: calc(100vh - 80px) !important;}"),
          plotOutput('graph2', height = "80%", width = "80%")
        ),

        absolutePanel(
          top = 70,
          right = 20,
          #Seleccionar la variable para
          selectInput(
            inputId = 'var11',
            label = h6(strong('Ordenar por:')),
            choices = c("promedio", "máximo", "mínimo"),
            width = 200
          )

        ) # close column
      ), # close widget page

      ## Para la gráfica de la Temporada de lluvias
      tabItem(
        tabName = "widgets3",
        br(),
        br(),
        fluidRow(
          tags$style(type = "text/css", "#graph4 {height: calc(100vh - 80px) !important;}"),
          plotOutput('graph4', height = "80%", width = "80%")
        ),

        absolutePanel(
          top = 70,
          right = 20,
          #Seleccionar la variable para Epoca
          selectInput(
            inputId = 'Epoca',
            label = h6(strong('Epoca:')),
            choices = levels(FloFru$Epoca),
            selected = "Floración",
            width = 200
          ),
          #Seleccionar la variable para Epoca
          selectInput(
            inputId = 'Tipo',
            label = h6(strong('Tipo:')),
            choices = levels(FloFru$Tipo),
            selected = "Silvestres",
            width = 200
          )

        ) # close absolutePanel
      ), # close widget3 page

      ## Para el waffle
      tabItem(
        tabName = "widgets2",
        br(),
        fluidRow(
          br(),
          tags$style(type = "text/css", "#graph3 {height: calc(100vh - 40px) !important;}"),
          plotOutput('graph3', height = "70%", width = "80%")
        ),

        absolutePanel(
          top = 100,
          right = 20,
          selectInput(
            inputId = "Estado2",
            label = h6(strong("Estado:")),
            choices = c(levels(Mex3$Estado)),
            selected = c("Oaxaca"),
            width = 200
          )
        ) # close column
      ), # close  tabItem

#####    
      # About Page
      tabItem(
        tabName = "conabio",
        br(),
        fluidRow(
          column(
            width = 12,
            h3(strong("Autores:"), align = "center")
          )
        ),
        fluidRow(
          column(
            width = 4,
            userBox(
              title = userDescription(
                title = "Dr. Alfonso Octavio Delgado Salinas",
                subtitle = "Responsable del Proyecto",
                type = 2,
                image = "Catbus.png",  # Asegúrate que esté en carpeta `www/`
              ),
              width = 12,  # Este 'width' es interno a la caja
              background = "blue",
              "Some text here",
              footer = "UNAM",
              collapsed = TRUE
            )
          ),
          column(
            width = 4,
            userBox(
              title = userDescription(
                title = "M. en C. Susana Gama López",
                subtitle = "Técnico Externo",
                type = 2,
                image = "Catbus.png",  # Asegúrate que esté en carpeta `www/`
              ),
              width = 12,  # Este 'width' es interno a la caja
              background = "blue",
              "Some text here",
              footer = "UNAM",
              collapsed = TRUE
            )
          ),
          column(
            width = 4,
            userBox(
              title = userDescription(
                title = "Dr. Enrique Martínez-Meyer",
                subtitle = "Co-responsables del Proyecto",
                type = 2,
                image = "Catbus.png",  # Asegúrate que esté en carpeta `www/`
              ),
              width = 12,  # Este 'width' es interno a la caja
              background = "blue",
              "Some text here",
              footer = "UNAM",
              collapsed = TRUE
            )
          ),
          column(
            width = 4,
            userBox(
              title = userDescription(
                title = "Dr. Jorge Alberto Acosta Gallegos",
                subtitle = "Colaborador Externo",
                type = 2,
                image = "Catbus.png",  # Asegúrate que esté en carpeta `www/`
              ),
              width = 12,  # Este 'width' es interno a la caja
              background = "blue",
              "Some text here",
              footer = "Institution",
              collapsed = TRUE
            )
          )
        ),
        br(),
        fluidRow(
          column(
            width = 12,
            h3(strong("CONABIO:"), align = "center")
          )
        ),
        fluidRow(
          column(
            width = 4,
            userBox(
              title = userDescription(
                title = "Oswaldo Oliveros Galindo",
                subtitle = "Especialista en Agrobiodiversidad",
                type = 2,
                image = "Catbus.png",  # Asegúrate que esté en carpeta `www/`
              ),
              width = 12,  # Este 'width' es interno a la caja
              background = "yellow",
              "Some text here",
              footer = a(href = "http://www.conabio.gob.mx/web/conocenos/CGAyRB_CA.html", "Conabio"),
              collapsed = TRUE
            )
          ),
          column(
            width = 4,
            userBox(
              title = userDescription(
                title = "Alejandro Ponce-Mendoza",
                subtitle = "Experto para el Análisis de Información de Agrobiodiversidad",
                type = 2,
                image = "APM.jpg",  # Asegúrate que esté en carpeta `www/`
              ),
              width = 12,  # Este 'width' es interno a la caja
              background = "yellow",
              "Trabajo en la",
              tags$a(href = "http://www.conabio.gob.mx/web/conocenos/CGAyRB_CPAM.html", "Conabio"),
              "para conservación de la agrobiodiversidad. Me interesa la visualización y análisis,
                                 de datos ecológicos. Mis publicaciones las puedes encontrar",
              tags$a(href = "https://scholar.google.com/citations?user=M1i6_loAAAAJ&hl=en", "aquí"),".",
              footer = p(tags$a(href = "http://www.conabio.gob.mx/web/conocenos/CGAyRB_CPAM.html", "Conabio"),
                         tags$a(href = "https://github.com/APonce73", "Github")),
              collapsed = TRUE
            )
          )
        ) # clore FluidRow
      ) # close tabItem about page
#####        
      
    ) # close tabItems
  ) # close body
) # end UI