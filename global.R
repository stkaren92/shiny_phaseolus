library(tidyverse)
library(readxl)
library(leaflet)
library(RColorBrewer)
library(plyr)
library(latticeExtra)
library(vegan)
library(plotly)
library(sp)
library(ggthemes)
library(ggmap)
library(ggalt)
library(colorspace)

Mex <- read_xlsx("data/PhaseolusEne2026_JE014_Unida.xlsx", 
                 sheet = "@PhaseolusEne2026", col_names = T)
Mex <- as.data.frame(Mex)

Mex2 <- Mex %>% 
  rename("Longitud" = "Long_dec",
         "Latitud" = "Lat_dec",
         "Habitat.1" = "Condición") %>% 
  mutate(RatingCol = as.factor(Especie))
levels(Mex2$RatingCol) <- rainbow_hcl(nlevels(Mex2$RatingCol),
                                      c = 70,
                                      l = 50)

Mex3 <- Mex2 %>%
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

