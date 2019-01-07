library(shiny)
library(shinydashboard)
library(dplyr)
library(markdown)
library(leaflet)
library(plotly)
library(httr)
library(rgdal)

dashboardPage(
  
  ## Dashboard Header
  dashboardHeader(title = "Drogas en México", titleWidth = 600), # close dashboard header
  
  ## Sidebar Menu
  dashboardSidebar(collapsed = FALSE, 
                   sidebarMenu(
                     menuItem("Home", tabName = "home", icon = icon("home")),
                     menuItem("Mapa", tabName = "widgets", icon = icon("map")),
                     menuItem("About", tabName = "about", icon = icon("user"))
                   )), # close sidebar menu
  
  ## Dashboard Body
  dashboardBody(tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "style.css")),
                
                ## Tab Items Pages
                tabItems(
                  
                  ## Home
                  tabItem(tabName = "home",
                          fluidRow(
                            column(width = 1),
                            column(width = 8),
                            column(width = 3))
                  ), # close home page
                  
                  ## Widgets
                  tabItem(tabName = "widgets",
                          column(width = 9,
                                 # Main View Box
                                 box(width = NULL, status = "danger", height = 500, leafletOutput("mymap1", width = "100%"))
                              #   fluidRow(
                              #     tabBox(title = " ", height = 425, width = 6,
                              #            tabPanel("Sales Summary", htmlOutput("SalesSummaryText")),
                              #            tabPanel("Sales Chart", plotlyOutput("salePricePlot", height = 400))),
                              #     tabBox(title = " ", height = 425, width = 6,
                              #            tabPanel("Rental Chart", plotlyOutput("rentalPricePlot", height = 400))))
                          ), # close main view box
                  
                  
                          column(width = 3,
                                 #br(),
                                 
                                 # Input Selector Box
                                 box(width = NULL, status = "danger",
                                     selectInput(inputId = "Cultivo",
                                                 label = h6("Cultivo:"), selected = levels(TablaFF$Cultivo)[1],
                                                 choices =  levels(TablaFF$Cultivo)),
                                     
                                     #Por Corridor
                                     selectInput(inputId = "Año",
                                                 label = h6("Año reportado:"), selected = levels(TablaFF$Año)[1],
                                                 choices = levels(TablaFF$Año)),
                                     
                                     #Por Plantios
                                     
                                     numericInput(inputId = "Plantíos", label = h6("Más de:"), value = 1, step = 20,
                                                  min = 1, max = 400),
                                     h6("plantíos en el municipio"),
                                     
                                    
                                     #Por Estado
                              #       selectInput(inputId = "Estado",
                              #                   label = h6("Estado:"), selected = levels(TablaFF$Estado),
                              #                   choices = levels(TablaFF$Año)),
                                     
                                     selectInput(inputId = "Estado",
                                                 label = h6("Estado:"),
                                                 c("All", levels(TablaFF$Estado)))
                                     
                                             
                                 ) # close input selector box
                                 
                                 # Selector and Slider for ROI
                              #   box(width = NULL, status = "warning",
                              #       sliderInput("budget", "Budget for buying property:", 
                              #                   min = 500000, max = 5000000, step = 100000, value = 1000000),
                              #       selectInput("rentalType", "Type of Rental:",
                              #                   choices = c("Studio", "1 Bedroom", "2 Bedrooms", "3+ Bedrooms"),
                              #                   selected = "1 Bedroom")
                              #   ), # close input selector box
                                 
                                
                          ) # close column
                  ), # close widget page
                  # About Page
                  tabItem(tabName = "about", 
                          column(width = 1),
                          column(width = 11,
                                 h2("About Author:"),
                                # img(src = "face.jpg"),
                          #       h3("Siyuan Li, Derek"),
                          #       h4("Data Science Fellow at NYC Data Science Academy"),
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
                                 a(href = "https://github.com/APonce73", "Github"))
                  ) # close about page
                ) # close tab item
  ) # close body
) # end UI