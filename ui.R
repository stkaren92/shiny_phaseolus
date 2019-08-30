library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyjs)
library(tidyverse)
library(markdown)
library(leaflet)
library(plotly)
library(httr)
library(rgdal)
library(tableHTML)


dashboardPagePlus(
  
  skin = "yellow",

  ## Dashboard Header
  dashboardHeaderPlus(title = "Frijol",
                  titleWidth = 200,
                  fixed = TRUE), # close dashboard header
  
  ## Sidebar Menu
  dashboardSidebar( width = 200,
                  shinyjs::useShinyjs(),
                  collapsed = F, 
                  disable = F,
                  sidebarMenu(id = "navbar",
                              #shinyjs::useShinyjs(),
                     menuItem("Introducción", tabName = "home", icon = icon("home")),
                     menuItem("Distribución", tabName = "widgets", icon = icon("map")),
                     menuItem("Altitud", tabName = "widgets1", icon = icon("certificate")),
                     menuItem("Floración y Crecimiento", tabName = "widgets3", icon = icon("adjust")),
                     menuItem("Gráfica de waffle", tabName = "widgets2", icon = icon("th")),
                     menuItem("Autores", tabName = "conabio", icon = icon("user"))
                              )
                   ), # close sidebar menu
  
  ## Dashboard Body
  dashboardBody(
             #tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "style.css")),
                
                ## Tab Items Pages
                tabItems( 
                  ## Home
                 tabItem(tabName = "home",
                #         tags$a(href = "https://humaneborders.org/", div(img(src = "logo-dipper-line.png", width = "200"), 
                #                                                         style = "text-align: left;")),
                br(),
                br(),
                         div(img(src = "Conabio_horizontal_rgb.png", width = "300"), style = "text-align: center;"),
                          fluidRow(
                            h2("Proyecto:", tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=JE&Numero=14", 
                                      strong("El género"), strong(em("Phaseolus (Leguminosae, Papilionoideae, Phaseoleae)")) , strong("para México")),
                              #strong("El género"), strong(em("Phaseolus (Leguminosae, Papilionoideae, Phaseoleae)")) , strong("para México"), 
                              align = "center"),
                         #   h3(strong("Autores:"), align = "center"),
                         #   h4("Responsable del Proyecto:", strong("Dr. Alfonso Octavio Delgado Salinas") , align = "center"),
                         #   h4("Técnico Externo:", strong("M. en C. Susana Gama López") , align = "center"),
                         #   h4("Co responsables del Proyecto:", strong("Dr. Enrique Martínez-Meyer") , align = "center"),
                         #   h4("Colaborador Externo:", strong("Dr. Jorge Alberto Acosta Gallegos") , align = "center"),
                            br(),
                            h2(strong("Introducción"), align = "center" ),
                            h4("Los frijoles (", em("Phaseolus sp."), ") pertenecen a la familia de las 
leguminosas (Leguminosae o Fabaceae), junto con los chícharos, habas, soya, mezquites, huizaches
con más de  19,000 especies. En el mundo se conocen alrededor de 150 especies de frijoles (Para mayor información visita la página de la", 
                        tags$a(href = "https://www.biodiversidad.gob.mx/usos/alimentacion/frijol.html", "Conabio"),")."),
                        
h4( "En América, el género", em(" Phaseolus"), "se distribuyen desde el sur de Canadá hasta 
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
    poblaciones silvestres (Delgado-Salinas et al., 2006)." ),

br(),
h2(strong("Visualización:"), align = "center"),
#h4("Esta visualización esta dividida en cuatro partes:"),

fluidRow(
  boxPlus(
    title = strong("Distribución"), 
    closable = FALSE, 
    width = 6,
    status = "warning", 
    solidHeader = FALSE, 
    collapsible = TRUE,
    h5("Visualiza todos los registros de ", em("Phaseolus"), "con coordinadas 
           geográficas del proyecto. Los valores se pueden filtrarse por: condición,
              estado y especie, permitiendo al usuario seleccionar las variables
              que más le interesen."), 
    img(id = "mapa" ,src = "MapDistribution1.png", 
        width = "280", align = "center",
        style = "cursor:pointer;")),
  
  boxPlus(
    title = strong("Altitud"), 
    closable = FALSE, 
    width = 6,
    status = "warning", 
    solidHeader = FALSE, 
    collapsible = TRUE,
    h5("¿La altitud afecta al firjol? El género", em("Phaseolus"), "puede 
           crecer desde el nivel del mar hasta arriba de los tres mil metros. 
           Esto ha permitido el que se pueda establecer en distintos ecosistemas 
           de nuestro país. La gráfica muestra esa gran adaptabilidad del 
           frijol en nuestro país."), 
    img(id = "altitud", src = "Altitud1.png", width = "400",
        align = "center",
        style = "cursor:pointer;")
    ),
 
  boxPlus(
    title = strong("Epoca de Crecimiento y Floración"), 
    closable = FALSE, 
    width = 6,
    status = "warning", 
    solidHeader = FALSE, 
    collapsible = TRUE,
    h5("¿Cuando crece y ccuando florece? El frijol esta en todo México
              y ¿todo el tiempo?, no todas las especies, pero el frijol nos
              acompaña todo el tiempo y en todos lados."), 
    img(id = "crecimiento" ,src = "Crecimiento1.png", width = "400",
        align = "center",
        style = "cursor:pointer;")
  ),
  
  boxPlus(
    title = strong("Gráfica de Waffle"), 
    closable = FALSE, 
    width = 6,
    status = "warning", 
    solidHeader = FALSE, 
    collapsible = TRUE,
    h5("¿Cual es la proporción de frijoles que hay en cada estado? Con
              la gráfica de waffle se puede observar de forma rápida la proporción
              de estos, ya que tiene 10 renglones x 10 columnas, es decir 
              100 cuadros que representan 100% de los registros de las especies
              por cada estado"), 
    img(id = "waffle", src = "WafflePlot.png", width = "300",
        align = "center",
        style = "cursor:pointer;")
  )
   )
                            
                            #htmlOutput("inc")
                                  ) #close fluidRow
                  ), # close home tab
                  
          
                  ## Para el mapa 1
                  tabItem(tabName = "widgets",
                          value = "distribucion_1",
                          br(),
                          #br(),
                          fluidRow(
                           # tags$head(tags$style("#mymap1 {height:90vh !important;}")),
                            tags$style("#mymap1 {height: calc(100vh - 80px) !important;}"),
                            leafletOutput('mymap1')
                          ),
                        absolutePanel(top = 90, right = 20, draggable = T,
                                     #Seleccionar el estado
                                     selectInput(inputId = "Habitat.1",
                                                 label = h6(id = "uno1", strong("Condición:")),
                                                 c("All", levels(Mex3$Habitat.1)), width = 200),
                                     
                                     tags$style(make_css(list('#uno1', 
                                                              c('color'), c('white')))),
                                     
                                      #Seleccionar el estado
                                     selectInput(inputId = "Estado",
                                                 label = h6(id = 'uno2', strong("Estado:") ),
                                                 c("All", levels(Mex3$Estado)), width = 200),
                                     
                                     tags$style(make_css(list('#uno2', 
                                                              c('color'), c('white')))),
                                    
                                    #Seleccionar la especie 
                                     selectInput(inputId = "Especie",
                                                 label = h6(id = "uno3", strong("Especie:")),
                                                 c("All", levels(Mex3$Especie)), width = 200),
                                    
                                    #Change color 
                                    tags$style(make_css(list('#uno3', 
                                                             c('color'), c('white'))))
                                
                          ) # close absolute panel
                  ), # close widget page
                  
                  ## Para la gráfica de la Altitud
                  tabItem(tabName = "widgets1",
                          br(),
                          fluidRow(
                            tags$style(type = "text/css", "#graph2 {height: calc(100vh - 80px) !important;}"),
                            plotOutput('graph2', height = "80%", width = "80%")
                          ),
                          
                          absolutePanel(top = 70, right = 20, 
                                     #Seleccionar la variable para  
                                 selectInput(inputId = 'var11', label = h6(strong('Ordenar por:') ), 
                                             choices = c("promedio", "máximo", "mínimo"), width = 200 )
                                  
                          ) # close column
                  ), # close widget page
                
                  ## Para la gráfica de la Temporada de lluvias
                  tabItem(tabName = "widgets3",
                          br(),
                          br(),
                          fluidRow(
                            tags$style(type = "text/css", "#graph4 {height: calc(100vh - 80px) !important;}"),
                            plotOutput('graph4', height = "80%", width = "80%")
                          ),
                          
                          absolutePanel(top = 70, right = 20, 
                                        #Seleccionar la variable para Epoca 
                                        selectInput(inputId = 'Epoca', label = h6(strong('Epoca:') ), 
                                                    choices = levels(FloFru$Epoca), 
                                                    selected = "Floración", width = 200 ),
                                        #Seleccionar la variable para Epoca 
                                        selectInput(inputId = 'Tipo', label = h6(strong('Tipo:') ), 
                                                    choices = levels(FloFru$Tipo), 
                                                    selected = "Silvestres",width = 200 )
                                        
                          ) # close absolutePanel
                  ), # close widget3 page

                  ## Para el waffle
                  tabItem(tabName = "widgets2",
                          br(),
                          fluidRow(
                            tags$style(type = "text/css", "#graph3 {height: calc(100vh - 40px) !important;}"),
                            plotOutput('graph3', height = "70%", width = "80%")
                          ),
                          
                          absolutePanel(top = 100, right = 20,
                                     selectInput(inputId = "Estado2",
                                                 label = h6(strong("Estado:")),
                                                 #c("All", levels(Mex3$Habitat.1)),
                                                 choices = c(levels(Mex3$Estado)),
                                                 selected = c("Oaxaca"), 
                                                 width = 200 )
                         
                                 
                          ) # close column
                  ), # close widget2 page
                    # About Page
                  tabItem(tabName = "conabio", 
                          br(),
                          fluidRow(
                            br(),
                            h3(strong("Autores:"), align = "center"),
                            widgetUserBox(
                              title = h4("Dr. Alfonso Octavio Delgado Salinas"),
                              subtitle = "Responsable del Proyecto",
                              width = 4,
                              type = 2,
                              src = "Catbus.png",
                              color = "blue",
                              "UNAM",
                              footer = NULL
                            ),
                            widgetUserBox(
                              title = h4("M. en C. Susana Gama López"),
                              subtitle = "Técnico Externo",
                              width = 4,
                              type = 2,
                              src = "Catbus.png",
                              color = "blue",
                              "UNAM",
                              footer = NULL
                            ),
                            widgetUserBox(
                              title = h4("Dr. Enrique Martínez-Meyer"),
                              subtitle = "Co-responsables del Proyecto",
                              width = 4,
                              type = 2,
                              src = "Catbus.png",
                              color = "blue",
                              "UNAM",
                              footer = NULL
                            ),
                            widgetUserBox(
                              title = h4("Dr. Jorge Alberto Acosta Gallegos"),
                              subtitle = "Colaborador Externo",
                              width = 4,
                              type = 2,
                              src = "Catbus.png",
                              color = "blue",
                              "FALTA",
                              footer = NULL
                            )
                            ),
                          fluidRow( 
                            
                            h3(strong("Conabio:"), align = "center"),
                            
                            widgetUserBox(
                              title = h4("Oswaldo Oliveros Galindo"),
                              subtitle = "Especialista en Agrobiodiversidad",
                              width = 4,
                              type = 2,
                              collapsible = TRUE,
                              #closable = TRUE,
                              src = "Catbus.png",
                              color = "yellow",
                              "Some text here!",
                              footer = a(href = "http://www.conabio.gob.mx/web/conocenos/CGAyRB_CA.html", "Conabio")
                            ),
                            
                            widgetUserBox(
                              title = h4("Alejandro Ponce-Mendoza"),
                              subtitle = "Experto para el Análisis de Información de Agrobiodiversidad",
                              width = 4,
                              type = 2,
                              src = "APM.jpeg",
                              color = "yellow",
                              h5("Trabajo en la", tags$a(href = "http://www.conabio.gob.mx/web/conocenos/CGAyRB_CPAM.html", "Conabio"),
                                "para conservación de la agrobiodiversidad. Me interesa la visualización y análisis,
                                 de datos ecológicos. Mis publicaciones las puedes encontrar",
                                tags$a(href = "https://scholar.google.com/citations?user=M1i6_loAAAAJ&hl=en", "aquí"  )),
                              footer = socialButton(
                                url = "https://github.com/APonce73",
                                type = "github"), tags$a(href = "http://www.conabio.gob.mx/web/conocenos/CGAyRB_CPAM.html", "Conabio")
                                #tags$a(href = "https://github.com/APonce73", "Github")
                                #h3(tags$a(href = "http://www.conabio.gob.mx/web/conocenos/CGAyRB_CPAM.html", "Conabio"),
                                #tags$a(href = "https://github.com/APonce73", "Github"),
                                #         )
                              
                            )
                            
              #              column(width = 11,
              #                     h2(strong("Colaboradores del documento:")),
              #                     img(src = "Catbus.png", width = "250"),
              #                     column(width = 3,
              #                            h3("Oswaldo Oliveros Galindo"),
              #                            h4("Especialista en Agrobiodiversidad"),
              #                            a(href = "http://www.conabio.gob.mx/web/conocenos/CGAyRB_CA.html", "Conabio")),
              #                     br(),
              #                     h3(strong("Visualización Shiny:")),
              #                     img(src = "APM.jpeg", width = "250"),
              #                     column(width = 3,
              #                            h3("Alejandro Ponce-M"),
              #                            h4("Experto para el Análisis de Información de Agrobiodiversidad"),
              #                            a(href = "http://www.conabio.gob.mx/web/conocenos/CGAyRB_CPAM.html", "Conabio"),
              #                            br(),
              #                            a(href = "https://github.com/APonce73", "Github"))
              #              )  
                          )
                          #column(width = 1),
                          
                                 
                          #       h4("Volunteer at DataKind.org"),
                          #       br(),
                          #       h4("Master of Applied Statisitcs, UCLA 2016 - 2018"),
                          #       h4("Bachelor of Financial Mathematics and Statistics, UCSB 2011 - 2015"),
                          #       br(),
                          #       h4("Rental Real Estate Broker Assistant, Underwriting 2018"),
                          #       h4("Quantitative Analyst Intern, Mingshi Investment Management, Shanghai, China 2016"),
                          #       h4("Investment Analyst Intern, Soochow Securities, Suzhou, Jiangsu, China 2015"),
                          #       br(),
                          #       a(href = "www.linkedin.com/in/siyuan-derek-li-b4663a49", "LinkedIn"),
                          #       br(),
                                 
                  ) # close about page
                ) # close tab item
  ) # close body
) # end UI