library(tidyverse)
library(readxl)
library(leaflet)
library(RColorBrewer)
library(plyr)
library(latticeExtra)
library(vegan)
library(plotly)
library(sp)
# library(rgdal)
library(ggthemes)
library(ggmap)
library(ggalt)

Mex <- read_xlsx("data/PhaseolusEne2026_JE014_Unida.xlsx", 
                 sheet = "@PhaseolusEne2026", col_names = T)
Mex <- as.data.frame(Mex)

Mex2 <- Mex %>% 
  rename("Longitud" = "Long_dec",
         "Latitud" = "Lat_dec",
         "Habitat.1" = "Condición") %>% 
  mutate(RatingCol = Especie)

Mex3 <- Mex2 %>%
  dplyr::mutate(RatingCol = revalue(RatingCol,  c("Phaseolus acutifolius var. acutifolius" = "#00441b",
                                                  "Phaseolus acutifolius var. tenuifolius" = "#006d2c",
                                                  "Phaseolus acutifolius" = "#006d2f",
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
                                                  "Phaseolus esquincensis" = "#f7fcc8",
                                                  "Phaseolus filiformis" = "#2b8cde",
                                                  "Phaseolus glabellus" = "#4eb3d3", 
                                                  "Phaseolus hintonii" = "#7bccc4",
                                                  "Phaseolus jaliscanus" = "#4d004b", 
                                                  "Phaseolus juquilensis" = "#810f7c", 
                                                  "Phaseolus laxiflorus" = "#88419d",
                                                  "Phaseolus leptophyllus" = "#8c6bb1",
                                                  "Phaseolus leptostachyus" = "#7f0000",
                                                  "Phaseolus lunatus" = "#b30005",
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
  dplyr::mutate(Estado = revalue(Estado,c("HUEHUETENANGO" = "Huehuetenango"))) %>%
  dplyr::mutate(Estado = revalue(Estado,c("NEW MEXICO" = "New Mexico"))) %>%
  dplyr::filter(Habitat.1 != "ND") %>%
  dplyr::filter(Habitat.1 != "Híbrido") %>% 
  mutate(Altitud = replace(Altitud, Altitud > 8000, NA))

Mex3$AnioColecta <- as.factor(Mex3$AnioColecta)
Mex3$Estado <- as.factor(Mex3$Estado)
Mex3$Habitat.1 <- as.factor(Mex3$Habitat.1)
Mex3$Especie <- as.factor(Mex3$Especie)
Mex3$RatingCol <- as.factor(Mex3$RatingCol)



#names(Mex3)
Mex4 <- Mex3 %>%
  filter(Estado != "Arizona") %>%
  filter(Estado != "Texas") %>%
  filter(Estado != "New Mexico")

Mex4$Estado <- factor(Mex4$Estado)
  

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


Mex7 <- Mex6 %>% 
  arrange(prom) %>% 
  mutate(ordenar1 = prom)

Mex8 <- Mex6 %>% 
  arrange(maximo) %>% 
  mutate(ordenar1 = maximo )

Mex9 <- Mex6 %>% 
  arrange(minimo) %>% 
  mutate(ordenar1 = minimo)

FloFru <- read_xlsx("data/Flor_fruc.xlsx", sheet = "Rdata", col_names = T)

FloFru$Epoca <- as.factor(FloFru$Epoca)
FloFru$Tipo <- as.factor(FloFru$Tipo)

