library(tidyverse)
library(readxl)
#library(taxize)
library(leaflet)
library(RColorBrewer)
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
library(ggalt)


###### Voronoi

#Para poner el voronoi en leaflet
#Código de https://rud.is/b/2015/07/26/making-staticinteractive-voronoi-map-layers-in-ggplotleaflet/


#SPointsDF_to_voronoi_SPolysDF <- function(sp) {
#  
#  # tile.list extracts the polygon data from the deldir computation
#  vor_desc <- tile.list(deldir(sp@coords[,1], sp@coords[,2]))
#  
#  lapply(1:(length(vor_desc)), function(i) {
#    
#    # tile.list gets us the points for the polygons but we
#    # still have to close them, hence the need for the rbind
#    tmp <- cbind(vor_desc[[i]]$x, vor_desc[[i]]$y)
#    tmp <- rbind(tmp, tmp[1,])
#    
#    # now we can make the Polygon(s)
#    Polygons(list(Polygon(tmp)), ID = i)
#    
#  }) -> vor_polygons
#  
#  # hopefully the caller passed in good metadata!
#  sp_dat <- sp@data
#  
#  # this way the IDs _should_ match up w/the data & voronoi polys
#  rownames(sp_dat) <- sapply(slot(SpatialPolygons(vor_polygons),
#                                  'polygons'),
#                             slot, 'ID')
#  
#  SpatialPolygonsDataFrame(SpatialPolygons(vor_polygons),
#                           data = sp_dat)
#}

#####

Mex <- read_xlsx("data/Phaseolus_Shiny.xlsx", sheet = "Phaseolus", col_names = T)
Mex <- as.data.frame(Mex)

Mex$LatitudSegundos <- as.character(Mex$LatitudSegundos)
Mex$LatitudSegundos <- as.numeric(Mex$LatitudSegundos)

Mex$LongitudSegundos <- as.character(Mex$LongitudSegundos)
Mex$LongitudSegundos <- as.numeric(Mex$LongitudSegundos)

#head(Mex)

Lat1 <- Mex %>%
  select(matches("Latitud")) %>%
  dplyr::mutate(Min = LatitudMinutos/60) %>%
  dplyr::mutate(Seg = LatitudSegundos/3600) %>%
  transmute(Latitud = LatitudGrados + Min + Seg)
#head(Lat1)

Long1 <- Mex %>%
  select(matches("Longitud")) %>%
  dplyr::mutate(Min = LongitudMinutos/60) %>%
  dplyr::mutate(Seg = LongitudSegundos/3600) %>%
  transmute(Longitud = abs(LongitudGrados) + Min + Seg) %>%
  transmute(Longitud = Longitud * -1)

#head(Long1)

Mex1 <- Mex %>%
  select(-matches("Longitud")) %>%
  select(-matches("Latitud")) %>%
  bind_cols(Lat1) %>%
  bind_cols(Long1)

Taxa1 <- str_split_fixed(Mex1$Taxa, " - ", 2)

#head(Taxa1)
#class(Taxa1)
Taxa1 <- as.data.frame(Taxa1)
names(Taxa1) <- c("Especie", "Autoridad")
Taxa1$RatingCol <- Taxa1$Especie

Mex2 <- Mex1 %>%
  bind_cols(Taxa1)

#head(Mex2)
#length(levels(Mex2$RatingCol))
#levels(Mex2$RatingCol)
#levels(Mex2$RatingCol)[1]

Mex3 <- Mex2 %>%
  #dplyr::mutate(RatingCol = revalue(RatingCol, levels(Mex2$RatingCol)[2] = "#00441b"))
  dplyr::mutate(RatingCol = revalue(RatingCol,  c("Phaseolus acutifolius var. acutifolius" = "#00441b",
                                                  "Phaseolus acutifolius var. tenuifolius" = "#006d2c",
                                                  "Phaseolus albescens" = "#238b45", 
                                                  "Phaseolus albiflorus" = "#41ae76", 
                                                  "Phaseolus amblyosepalus" = "#66c2a4",
                                                  "Phaseolus angustissimus" = "#99d8c9", 
                                                  "Phaseolus anisophyllus" = "#004529", 
                                                  "Phaseolus campanulatus" = "#006837",
                                                  "Phaseolus carterae" = "#238443", 
                                                  "Phaseolus chiapasanus" = "#41ab5d", 
                                                  "Phaseolus coccineus" = "#78c679",
                                                  "Phaseolus dasycarpus" = "#addd8e", 
                                                  "Phaseolus dumosus" = "#d9f0a3", 
                                                  "Phaseolus esperanzae" = "#f7fcb9",
    #                                              "Phaseolus esquincensis" = "#0868ac",
                                                  "Phaseolus filiformis" = "#2b8cde",
                                                  "Phaseolus glabellus" = "#4eb3d3", 
                                                  "Phaseolus hintonii" = "#7bccc4",
                                                  "Phaseolus jaliscanus" = "#4d004b", 
                                                  "Phaseolus juquilensis" = "#810f7c", 
                                                  "Phaseolus laxiflorus" = "#88419d",
                                                  "Phaseolus leptophyllus" = "#8c6bb1",
                                                  "Phaseolus leptostachyus" = "#7f0000",
                                                  "Phaseolus lunatus var. lunatus" = "#b30000",
                                                  "Phaseolus lunatus var. silvester" = "#d7301f",
                                                  "Phaseolus maculatifolius" = "#ef6548", 
                                                  "Phaseolus maculatus" = "#fc8d59",
                                                  "Phaseolus macvaughii" = "#fdbb84", 
                                                  "Phaseolus marechalii" = "#662506", 
                                                  "Phaseolus micranthus" = "#993404",
                                                  "Phaseolus microcarpus" = "#cc4c02", 
                                                  "Phaseolus neglectus" = "#ec7014", 
                                                  "Phaseolus nelsonii" = "#fe9929",
                                                  "Phaseolus nodosus" = "#fec44f",
                                                  "Phaseolus novoleonensis" = "#67001f",
                                                  "Phaseolus oaxacanus" = "#980043",
                                                  "Phaseolus oligospermus" = "#ce1256",
                                                  "Phaseolus parvifolius" = "#e7298a",
                                                  "Phaseolus parvulus" = "#df65b0",
                                                  "Phaseolus pauciflorus" = "#c994c7",
                                                  "Phaseolus pedicellatus" = "#081d58", 
                                                  "Phaseolus perplexus" = "#253494",
                                                  "Phaseolus plagiocylix" = "#225ea8",
                                                  "Phaseolus pluriflorus" = "#1d91c0",
                                                  "Phaseolus purpusii" = "#41b6c4",
                                                  "Phaseolus reticulatus" = "#7fcdbb", 
                                                  "Phaseolus ritensis" = "#2171b5",
                                                  "Phaseolus rotundatus" = "#4292c6",
                                                  "Phaseolus salicifolius" = "#6baed6", 
                                                  "Phaseolus scabrellus" = "#9ecae1",
                                                  "Phaseolus sonorensis" = "#c6dbef",
                                                  "Phaseolus tenellus" = "#deebf7",
                                                  #levels(Mex2$RatingCol)[] = "#67000d", 
                                                  #levels(Mex2$RatingCol)[] = "#a50f15", 
                                                  #levels(Mex2$RatingCol)[] = "#cb181d",
                                                  #levels(Mex2$RatingCol)[] = "#ef3b2c", 
                                                  #levels(Mex2$RatingCol)[] = "#fb6a4a",
                                                  "Phaseolus tuerckheimii" = "#fc9272", 
                                                  "Phaseolus viridis" = "#fcbba1", 
                                                  "Phaseolus vulgaris" = "#fed976",
                                                  "Phaseolus xanthotrichus" = "#bd0026", 
                                                  "Phaseolus xolocotzii" = "#e31a1c", 
                                                  "Phaseolus zimapanensis" = "#fc4e2a"))) %>%
  dplyr::mutate(val = 1) %>%
  dplyr::mutate(Estado = revalue(Estado,c("YUCATÁN" = "Yucatán"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("QUINTANA ROO" = "Quintana Roo"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("TAMAULIPAS" = "Tamaulipas"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("TLAXCALA" = "Tlaxcala"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("JALISCO" = "Jalisco"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("HIDALGO" = "Hidalgo"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("GUERRERO" = "Guerrero"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("SONORA" = "Sonora"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("BAJA CALIFORNIA SUR" = "Baja California Sur"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("GUANAJUATO" = "Guanajuato"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("PUEBLA" = "Puebla"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("OAXACA" = "Oaxaca"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("CHIAPAS" = "Chiapas"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("DURANGO" = "Durango"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("TABASCO" = "Tabasco"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("ZACATECAS" = "Zacatecas"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("NUEVO LEÓN" = "Nuevo León"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("NAYARIT" = "Nayarit"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("AGUASCALIENTES" = "Aguascalientes"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("CHIHUAHUA" = "Chihuahua"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("VERACRUZ DE IGNACIO DE LA LLAVE" = "Veracruz"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("CAMPECHE" = "Campeche"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("SINALOA" = "Sinaloa"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("MICHOACÁN DE OCAMPO" = "Michoacán"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("MÉXICO" = "México"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("DISTRITO FEDERAL" = "Ciudad de México"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("MORELOS" = "Morelos"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("QUERÉTARO DE ARTEAGA" = "Querétaro"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("COAHUILA DE ZARAGOZA" = "Coahuila"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("COLIMA" = "Colima"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("SAN LUIS POTOSÍ" = "San Luis Potosí"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("BAJA CALIFORNIA" = "Baja California"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("ARIZONA" = "Arizona"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("TEXAS" = "Texas"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("NEW MEXICO" = "New Mexico"))) %>%
  dplyr::filter(Habitat.1 != "ND") %>%
  dplyr::filter(Habitat.1 != "Híbrido")

head(Mex3)
str(Mex3)
Mex3$AnioColecta <- as.factor(Mex3$AnioColecta)
Mex3$Estado <- as.factor(Mex3$Estado)
Mex3$Habitat.1 <- as.factor(Mex3$Habitat.1)



#names(Mex3)
Mex4 <- Mex3 %>%
  filter(Estado != "Arizona") %>%
  filter(Estado != "Texas") %>%
  filter(Estado != "New Mexico")

Mex4$Estado <- factor(Mex4$Estado)
  

##### Diagramas de Voronoi de acuerdo a un trabajo de Chisato
# https://chichacha.netlify.com/2018/11/10/voronoi-diagram-with-ggvoronoi-package-with-train-station-data/

#########################
########################
#library("mxmaps")
#library("geojsonio")
#library("jsonlite")
##
#
## Convert the topoJSON to spatial object

#tmpdir <- tempdir()

## have to use RJSONIO or else the topojson isn't valid

#write(RJSONIO::toJSON(mxstate.topoJSON), file.path(tmpdir, "mun.topojson"))
#muns <- topojson_read(file.path(tmpdir, "mun.topojson"))
#
#shapefile_df_1 <- fortify(muns)

##Los groups son los diferentes shapefiles de cada estado
## Sólo seleccionaré los correspondientes a las tierras continetales
#
#summary(shapefile_df_1$group)
#levels(shapefile_df_1$id)

#Estos son los códigos para cada group de acuerdo a su estado
# 4.1= Jalisco
# 20.1= Veracruz
# 15.1= Zacatecas
# 19.1= Chihuahua
# 1.1= Quintana Roo
# 2.1= Tamaulipas
# 3.1= Tlaxcala
# 5.1= Hidalgo
# 6.1= Guerrero
# 7.1= Sonora
# 8.1= BCS
# 9.1= Guanajuato
# 10.1= Puebla
# 11.1= Oaxaca
# 12.1= Chiapas
# 13.1= Durango
# 14.1= Tabasco
# 16.1= Nuevo Leon
# 17.1= Nayarit
# 18.1= Aguascalientes
#21.1= Campeche
# 22.1= Sinaloa
# 23.1= Michoacan
# 24.1= Edo Mex
# 25.1= CDMX
# 26.1= Morelos
# 27.1= Queretaro
# 28.1= Coahuila
# 29.1= Colima
# 30.1= San L Potosi
# 31.1= BC Norte
# 0.1= Yucatan

#target <- c("0.1", "1.1", "2.1", "3.1", "4.1", "5.1", "6.1",
#            "7.1", "8.1", "9.1", "10.1", "11.1", "12.1", "13.1", "14.1", 
#            "15.1", "16.1", "17.1", "18.1", "19.1", "20.1",
#            "21.1", "22.1", "23.1", 
#            "24.1", "25.1", "26.1", "27.1", "28.1", "29.1", "30.1", 
#            "31.1")


#shapefile_df <- shapefile_df_1 %>%
#  filter(geometry %in% target) %>%
#  dplyr::mutate(id = revalue(id,c("0.1" = "Yucatán")))
#  dplyr::mutate(group = revalue(group,c("1.1" = "Quintana Roo"))) %>%
#  dplyr::mutate(group = revalue(group,c("2.1" = "Tamaulipas"))) %>%
#  dplyr::mutate(group = revalue(group,c("3.1" = "Tlaxcala"))) %>%
#  dplyr::mutate(group = revalue(group,c("4.1" = "Jalisco"))) %>%
#  dplyr::mutate(group = revalue(group,c("5.1" = "Hidalgo"))) %>%
#  dplyr::mutate(group = revalue(group,c("6.1" = "Guerrero"))) %>%
#  dplyr::mutate(group = revalue(group,c("7.1" = "Sonora"))) %>%
#  dplyr::mutate(group = revalue(group,c("8.1" = "Baja California Sur"))) %>%
#  dplyr::mutate(group = revalue(group,c("9.1" = "Guanajuato"))) %>%
#  dplyr::mutate(group = revalue(group,c("10.1" = "Puebla"))) %>%
#  dplyr::mutate(group = revalue(group,c("11.1" = "Oaxaca"))) %>%
#  dplyr::mutate(group = revalue(group,c("12.1" = "Chiapas"))) %>%
#  dplyr::mutate(group = revalue(group,c("13.1" = "Durango"))) %>%
#  dplyr::mutate(group = revalue(group,c("14.1" = "Tabasco"))) %>%
#  dplyr::mutate(group = revalue(group,c("15.1" = "Zacatecas"))) %>%
#  dplyr::mutate(group = revalue(group,c("16.1" = "Nuevo León"))) %>%
#  dplyr::mutate(group = revalue(group,c("17.1" = "Nayarit"))) %>%
#  dplyr::mutate(group = revalue(group,c("18.1" = "Aguascalientes"))) %>%
#  dplyr::mutate(group = revalue(group,c("19.1" = "Chihuahua"))) %>%
#  dplyr::mutate(group = revalue(group,c("20.1" = "Veracruz"))) %>%
#  dplyr::mutate(group = revalue(group,c("21.1" = "Campeche"))) %>%
#  dplyr::mutate(group = revalue(group,c("22.1" = "Sinaloa"))) %>%
#  dplyr::mutate(group = revalue(group,c("23.1" = "Michoacán"))) %>%
#  dplyr::mutate(group = revalue(group,c("24.1" = "México"))) %>%
#  dplyr::mutate(group = revalue(group,c("25.1" = "Ciudad de México"))) %>%
#  dplyr::mutate(group = revalue(group,c("26.1" = "Morelos"))) %>%
#  dplyr::mutate(group = revalue(group,c("27.1" = "Querétaro"))) %>%
#  dplyr::mutate(group = revalue(group,c("28.1" = "Coahuila"))) %>%
#  dplyr::mutate(group = revalue(group,c("29.1" = "Colima"))) %>%
#  dplyr::mutate(group = revalue(group,c("30.1" = "San Luis Potosí"))) %>%
#  dplyr::mutate(group = revalue(group,c("31.1" = "Baja California")))
#mutate(group = revalue(group,c("" = ""))) %>%

#Para la Altitud
Mex5 <- Mex4 %>%
  select(Especie, Altitud) %>%
  group_by(Especie) %>%
  summarise(minimo = min(Altitud))

Mex5.1 <- Mex4 %>%
  select(Especie, Altitud) %>%
  group_by(Especie) %>%
  summarise(prom = mean(Altitud))


Mex6 <- Mex4 %>%
  select(Especie, Altitud) %>%
  filter(Altitud < 9000) %>%
  group_by(Especie) %>%
  summarise(maximo = max(Altitud)) %>%
  full_join(Mex5, by = "Especie") %>%
  full_join(Mex5.1, by = "Especie") %>%
  mutate(rango = maximo - minimo) %>%
  na.omit()



