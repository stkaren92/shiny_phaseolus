library(shiny)
library(shinyjs)
library(shinydashboard)
library(tidyverse)
library(markdown)
library(leaflet)
library(plotly)
library(httr)
library(rgdal)
#library(shinybulma)

dashboardPage(
  
  skin = "yellow",

  ## Dashboard Header
  dashboardHeader(title = "Frijol",
                  titleWidth = 300), # close dashboard header
  
  ## Sidebar Menu
  dashboardSidebar( width = 200,
                  collapsed = F, disable = F,
                   sidebarMenu(
                    # shinyjs::useShinyjs(),
                     menuItem("Introducción", tabName = "home", icon = icon("home")),
                     menuItem("Distribución", tabName = "widgets", icon = icon("map")),
                     menuItem("Altitud", tabName = "widgets1", icon = icon("certificate")),
                     menuItem("Epoca de Crecimiento", tabName = "widgets3", icon = icon("adjust")),
                     menuItem("Gráfica de waffle", tabName = "widgets2", icon = icon("th")),
                     menuItem("Conabio", tabName = "conabio", icon = icon("user"))
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
                         div(img(src = "Conabio_horizontal_rgb.png", width = "300"), style = "text-align: center;"),
                          fluidRow(
                            h2(tags$a(href = "http://www.conabio.gob.mx/institucion/cgi-bin/datos2.cgi?Letras=JE&Numero=14", "Proyecto:"),
                              strong("El género"), strong(em("Phaseolus (Leguminosae, Papilionoideae, Phaseoleae)")) , strong("para México"), align = "center"),
                            h3(strong("Autores:"), align = "center"),
                            h4("Responsable del Proyecto:", strong("Dr. Alfonso Octavio Delgado Salinas") , align = "center"),
                            h4("Técnico Externo:", strong("M. en C. Susana Gama López") , align = "center"),
                            h4("Co responsables del Proyecto:", strong("Dr. Enrique Martínez-Meyer") , align = "center"),
                            h4("Colaborador Externo:", strong("Dr. Jorge Alberto Acosta Gallegos") , align = "center"),
                            br(),
                            h2(strong("Introducción"), align = "center" ),
                            h4("Los frijoles (", em("Phaseolus sp."), ") pertenecen a la familia de las 
leguminosas (Leguminosae o Fabaceae), junto con los chícharos, habas, soya, mezquites, huizaches
con más de  19,000 especies. En el mundo se conocen alrededor de 150 especies de frijoles (Para mayor información visita la página de la", 
                        tags$a(href = "https://www.biodiversidad.gob.mx/usos/alimentacion/frijol.html", "Conabio"),")"),
                        
h4( "En América, el género", em(" Phaseolus"), "se distribuyen desde el sur de Canadá hasta 
    el norte  de  Argentina. Existen alrededor de 70 especies, de las cuales cinco han sido domesticadas:",
    em("Phaseolus acutifolius"), "A. Gray (teparí o escumite),", em("Phaseolus coccineus"), 
    "L. (ayocote, tecomarí, botil),", em("Phaseolus dumosus"), "Macfadyen (gordo, acalete),", 
    em("Phaseolus lunatus"), "L. (ib, comba, patachete, navajita, lima) y", 
    em("Phaseolus vulgaris") ,"L. (cimatl, frejol, frijol, etc.) y todas pueden cohabitar con sus
    poblaciones silvestres (Delgado-Salinas et al., 2006)" ),

br(),
h2(strong("Visualización:"), align = "center"),
h4("Esta visualización esta dividida en cuatro partes:"),

fluidRow(
  column(7,
         wellPanel(
           h3(strong("Distribución")),
           h4("Visualiza todos los registros de ", em("Phaseolus"), "con coordinadas 
           geográficas del proyecto. Los valores se pueden filtrarse por: condición,
              estado y especie ")
         )),
  
  column(5,
         wellPanel(
           img(src = "MapDistribution.png", width = "400")
           #onclick("MapDistribution.png", toggle("Distribución"))
         ))
),

fluidRow(
  column(7,
         wellPanel(
           h3(strong("Altitud")),
           h4("El género", em("Phaseolus"), "puede crecer desde una altitud 
           a nivel del mar hasta arriba de los tres mil metros. Esto ha permitido 
           el que se pueda establecer en distitnos ecosistemas de nuestro país")
         )),
  
  column(5,
         wellPanel(
           img(src = "AltitudPlot.png", width = "400")
         ))
),

fluidRow(
  column(6,
         wellPanel(
           h3(strong("Epoca de Crecimiento")),
           h4("")
         )),
  
  column(6,
         wellPanel(
           img(src = "Crecimiento.png", width = "400")
         ))
),

###PAra la gráfica de Waffle
fluidRow(
  column(6,
         wellPanel(
           h3(strong("Waffle")),
           h4("Cual es la proporción de frijoles que hay en cada estado. Con
              la gráfica de waffle se puede observar de forma rápida la proporción
              de estos. La gráfica tiene 10 renglones x 10 columnas, es decir 
              100 cuadros que representan la proporción ")
         )),
  
  column(6,
         wellPanel(
           img(src = "WafflePlot.png", width = "400")
         ))
),
                        h4("Las plantas de frijol son hierbas rastreras y trepadoras con 
foliolos de tres hojas. El color de sus flores tiene tonalidades rosas, 
                          lilas y violetas. Sus semillas, lo que conocemos como frijol propiamente, 
                          tiene forma de riñón y crecen en una vaina comestible como legumbre 
                          (ejotes, del náhuatl exotl). Como otras leguminosas, estas plantas en sus raíces 
                          tienen nódulos con bacterias fijadoras de nitrógeno. 
                          El frijol contiene carbohidratos, alto contenido de proteínas, fibra, 
                          grasa y minerales (calcio y hierro) y vitaminas del complejo B como la niacina, 
                          riboflavina, ácido fólico y tiamina.")

                            
                            #htmlOutput("inc")
                                  ) #close fluidRow
                  ), # close home tab
                  
          
                  ## Para el mapa 1
                  tabItem(tabName = "widgets",
                          fluidRow(
                           # tags$head(tags$style("#mymap1 {height:90vh !important;}")),
                            tags$style(type = "text/css", "#mymap1 {height: calc(100vh - 80px) !important;}"),
                            leafletOutput('mymap1')
                          ),
                        absolutePanel(top = 90, right = 20, draggable = T,
                                     #Seleccionar el estado
                                     selectInput(inputId = "Habitat.1",
                                                 label = h6(strong("Condición:")),
                                                 c("All", levels(Mex3$Habitat.1)), width = 200),
                                     
                                     
                                      #Seleccionar el estado
                                     selectInput(inputId = "Estado",
                                                 label = h6("Estado:"),
                                                 c("All", levels(Mex3$Estado)), width = 200),
                                    
                                    #Seleccionar la especie 
                                     selectInput(inputId = "Especie",
                                                 label = h6("Especie:"),
                                                 c("All", levels(Mex3$Especie)), width = 200)
                                
                          ) # close absolute panel
                  ), # close widget page
                  
                  ## Para la gráfica de la Altitud
                  tabItem(tabName = "widgets1",
                          fluidRow(
                            tags$style(type = "text/css", "#graph2 {height: calc(100vh - 80px) !important;}"),
                            plotOutput('graph2', height = "80%", width = "80%")
                          ),
                          
                          absolutePanel(top = 70, right = 20, 
                                     #Seleccionar la variable para  
                                 selectInput(inputId = 'var11', label = h6(strong('Ordenar por:') ), 
                                             choice = c("promedio", "máximo", "mínimo"), width = 200 )
                                  
                          ) # close column
                  ), # close widget page
                
                  ## Para la gráfica de la Temporada de lluvias
                  tabItem(tabName = "widgets3",
                          fluidRow(
                            tags$style(type = "text/css", "#graph4 {height: calc(100vh - 80px) !important;}"),
                            plotOutput('graph4', height = "80%", width = "80%")
                          ),
                          
                          absolutePanel(top = 70, right = 20, 
                                        #Seleccionar la variable para Epoca 
                                        selectInput(inputId = 'Epoca', label = h6(strong('Epoca:') ), 
                                                    choice = levels(FloFru$Epoca), 
                                                    selected = "Floración", width = 200 ),
                                        #Seleccionar la variable para Epoca 
                                        selectInput(inputId = 'Tipo', label = h6(strong('Tipo:') ), 
                                                    choice = levels(FloFru$Tipo), 
                                                    selected = "Silvestres",width = 200 )
                                        
                          ) # close absolutePanel
                  ), # close widget3 page

                  ## Para el waffle
                  tabItem(tabName = "widgets2",
                          fluidRow(
                            tags$style(type = "text/css", "#graph3 {height: calc(100vh - 40px) !important;}"),
                            plotOutput('graph3', height = "70%", width = "80%")
                          ),
                          
                          absolutePanel(top = 100, right = 20,
                                     selectInput(inputId = "Estado2",
                                                 label = h6(strong("Estado:")),
                                                 choice = c(levels(Mex3$Estado)),
                                                 selected = c("Oaxaca"), width = 200 )
                                     
                                 
                          ) # close column
                  ), # close widget2 page
                    # About Page
                  tabItem(tabName = "conabio", 
                          fluidRow(
                            column(width = 11,
                                   h2(strong("Colaboradores del documento:")),
                                   img(src = "APM.jpeg", width = "250"),
                                   column(width = 3,
                                          h3("Oswaldo Oliveros Galindo"),
                                          h4("Especialista en Agrobiodiversidad"),
                                          a(href = "http://www.conabio.gob.mx/web/conocenos/CGAyRB_CA.html", "Conabio")),
                                   br(),
                                   h3(strong("Visualización Shiny:")),
                                   img(src = "APM.jpeg", width = "250"),
                                   column(width = 3,
                                          h3("Alejandro Ponce-M"),
                                          h4("Experto para el Análisis de Información de Agrobiodiversidad"),
                                          a(href = "http://www.conabio.gob.mx/web/conocenos/CGAyRB_CPAM.html", "Conabio"),
                                          br(),
                                          a(href = "https://github.com/APonce73", "Github"))
                            )  
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