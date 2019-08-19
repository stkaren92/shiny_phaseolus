library(shiny)
#library(shinyjs)
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
                  titleWidth = 200), # close dashboard header
  
  ## Sidebar Menu
  dashboardSidebar(collapsed = F, disable = F,
                   sidebarMenu(
                     menuItem("Introducción", tabName = "home", icon = icon("home")),
                     menuItem("Mapa", tabName = "widgets", icon = icon("map")),
                     menuItem("Voronoi", tabName = "widgets1", icon = icon("certificate")),
                     menuItem("Waffle", tabName = "widgets2", icon = icon("th")),
                     menuItem("Conabio", tabName = "conabio", icon = icon("user"))
                     
                   )), # close sidebar menu
  
  ## Dashboard Body
  dashboardBody(tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "style.css")),
                
                ## Tab Items Pages
                tabItems(
                  ## Home
                 tabItem(tabName = "home",
                #         tags$a(href = "https://humaneborders.org/", div(img(src = "logo-dipper-line.png", width = "200"), 
                #                                                         style = "text-align: left;")),
                         div(img(src = "Conabio_horizontal_rgb.png", width = "400"), style = "text-align: center;"),
                          fluidRow(
                            h1(tags$a(href = "http://www.conabio.gob.mx/institucion/proyectos/resultados/InfJE014.pdf", "Proyecto:"),
                              strong("El género"), strong(em("Phaseolus (Leguminosae, Papilionoideae, Phaseoleae)")) , strong("para México"), align = "center"),
                            h3(strong("Autores:"), align = "center"),
                            h3("Responsable del Proyecto:", strong("Dr. Alfonso Octavio Delgado Salinas") , align = "center"),
                            h3("Técnico Externo:", strong("M. en C. Susana Gama López") , align = "center"),
                            h3("Co responsables del Proyecto:", strong("Dr. Enrique Martínez-Meyer") , align = "center"),
                            h3("Colaborador Externo:", strong("Dr. Jorge Alberto Acosta Gallegos") , align = "center"),
                            br(),
                            h2(strong("Introducción") ),
                            h4("Los frijoles (", em("Phaseolus sp."), ") pertenecen a la familia de las 
leguminosas (Leguminosae o Fabaceae), junto con los chícharos, habas, soya, mezquites, huizaches,
y alrededor de 19,400 especies. En el mundo se conocen alrededor de 150 especies de frijoles (Para mayor información visita la página de la", 
                        tags$a(href = "https://www.biodiversidad.gob.mx/usos/alimentacion/frijol.html", "Conabio"),")"),
                        
h4( "En América, el género", em(" Phaseolus"), "se distribuyen desde el sur de Canadá a la Florida  y sur de EUA.  
    En México, crecen en  las  zonas  montañosas  (principalmente en  la  vertiente  del  Pacífico)  
    y  algunas  de ellas llegan a Centroamérica y Sudamérica, donde se distribuyenen los Andes hasta 
    el norte  de  Argentina." ),
br(),
h2(strong("Visualización:")),
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
                                  )
                  ), # close home page
                  
                  ## Para el mapa 1
                  tabItem(tabName = "widgets",
                          dashboardBody(
                            tags$style(type = "text/css", "#mymap1 {height: calc(100vh - 80px) !important;}"),
                            leafletOutput('mymap1', width = "100%", height = "100%")
                          ),
                        
                  
                  
                        fixedPanel(top = 130, left = 250, draggable = T,
                                     #Seleccionar el estado
                                     selectInput(inputId = "Habitat.1",
                                                 label = h6("Condición:"),
                                                 c("All", levels(Mex3$Habitat.1))),
                                     
                                     
                                      #Seleccionar el estado
                                     selectInput(inputId = "Estado",
                                                 label = h6("Estado:"),
                                                 c("All", levels(Mex3$Estado))),
                                    
                                    #Seleccionar la especie 
                                     selectInput(inputId = "Especie",
                                                 label = h6("Especie:"),
                                                 c("All", levels(Mex3$Especie)))
                                
                          ) # close absolute panel
                  ), # close widget page
                  
                  ## Para el mapa 2
                  tabItem(tabName = "widgets1",
                          dashboardBody(
                            tags$style(type = "text/css", "#graph2 {height: calc(100vh - 80px) !important;}"),
                            plotOutput('graph2', height = "100%")
                          ),
                  #        column(width = 10,
                  #               # Main View Box
                  #               box(width = NULL, status = "danger", height = 500, plotOutput("graph2", width = "100%"))
                  #               #   fluidRow(
                  #               #     tabBox(title = " ", height = 425, width = 6,
                  #               #            tabPanel("Sales Summary", htmlOutput("SalesSummaryText")),
                  #               #            tabPanel("Sales Chart", plotlyOutput("salePricePlot", height = 400))),
                  #               #     tabBox(title = " ", height = 425, width = 6,
                  #               #            tabPanel("Rental Chart", plotlyOutput("rentalPricePlot", height = 400))))
                  #        ), # close main view box
                          
                          
                          absolutePanel(top = 100, right = 40,
                                 #br(),
                                 
                                 # Input Selector Box
                                     
                                     #Seleccionar el estado
                                     selectInput(inputId = "Estado1",
                                                 label = h6("Estado:"),
                                                 choice = c(levels(Mex4$Estado)),
                                                 selected = c("Oaxaca")),
                                     
                                     #Seleccionar la especie 
                                     selectInput(inputId = "Especie1",
                                                 label = h6("Especie:"),
                                                 c("All", levels(Mex4$Especie)))
                                 
                          ) # close column
                  ), # close widget page
                
                  ## Para el waffle
                  tabItem(tabName = "widgets2",
                          dashboardBody(
                            tags$style(type = "text/css", "#graph3 {height: calc(100vh - 80px) !important;}"),
                            plotOutput('graph3', height = "100%")
                          ),
                          
                     #     column(width = 10,
                    #             # Main View Box
                     #            box(width = NULL, status = "danger", height = 500, plotOutput("graph3", width = "100%"))
                                 #   fluidRow(
                                 #     tabBox(title = " ", height = 425, width = 6,
                                 #            tabPanel("Sales Summary", htmlOutput("SalesSummaryText")),
                                 #            tabPanel("Sales Chart", plotlyOutput("salePricePlot", height = 400))),
                                 #     tabBox(title = " ", height = 425, width = 6,
                                 #            tabPanel("Rental Chart", plotlyOutput("rentalPricePlot", height = 400))))
                      #    ), # close main view box
                          
                          
                          absolutePanel(top = 100, right = 20,
                                        #br(),
                                 
                                 # Input Selector Box
                                     
                                     #Seleccionar el estado
                                     selectInput(inputId = "Estado2",
                                                 label = h6("Estado:"),
                                                 choice = c(levels(Mex3$Estado)),
                                                 selected = c("Oaxaca"))
                                     
                                 
                          ) # close column
                  ), # close widget page
                    # About Page
                  tabItem(tabName = "conabio", 
                          #column(width = 1),
                          column(width = 11,
                                 h2(strong("Colaboradores del documento:")),
                                 br(),
                                 h2(strong("Colaboradores de la visualización Shiny:")),
                                 img(src = "APM.jpeg", width = "250"),
                                 column(width = 3,
                                        h3("Alejandro Ponce-M"),
                                        h4("Experto para el Análisis de Información de Agrobiodiversidad"),
                                        a(href = "https://github.com/APonce73", "Github"))
                                        )
                                 
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