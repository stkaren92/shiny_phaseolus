#Install package
#install.packages("deldir", dependencies = TRUE)

#Para instalar rgdal
#install.packages("rgdal", repos = "http://cran.us.r-project.org", type = "source")

#library(devtools)
#devtools::install_github("diegovalle/mxmaps")
library(sp)
library(leaflet)
library(deldir)
library(ggthemes)
library(tidyverse)
library(rgdal)
library(mxmaps)
library(plotly)
library(latticeExtra)
library(ggforce)
library(plyr)
library(dplyr)

#library(rgeos)
#library(htmltools)

#getwd()
 #setwd("/Users/alejandroponce/Dropbox/JANO/2018/GabrielTamariz")
#dir()

########################
########################

#Para poner el voronoi en leaflet
#Código de https://rud.is/b/2015/07/26/making-staticinteractive-voronoi-map-layers-in-ggplotleaflet/


SPointsDF_to_voronoi_SPolysDF <- function(sp) {
  
  # tile.list extracts the polygon data from the deldir computation
  vor_desc <- tile.list(deldir(sp@coords[,1], sp@coords[,2]))
  
  lapply(1:(length(vor_desc)), function(i) {
    
    # tile.list gets us the points for the polygons but we
    # still have to close them, hence the need for the rbind
    tmp <- cbind(vor_desc[[i]]$x, vor_desc[[i]]$y)
    tmp <- rbind(tmp, tmp[1,])
    
    # now we can make the Polygon(s)
    Polygons(list(Polygon(tmp)), ID = i)
    
  }) -> vor_polygons
  
  # hopefully the caller passed in good metadata!
  sp_dat <- sp@data
  
  # this way the IDs _should_ match up w/the data & voronoi polys
  rownames(sp_dat) <- sapply(slot(SpatialPolygons(vor_polygons),
                                  'polygons'),
                             slot, 'ID')
  
  SpatialPolygonsDataFrame(SpatialPolygons(vor_polygons),
                           data = sp_dat)
}

########################
########################

#Usando el Shapefile del paquete mxmaps
#Website: https://www.diegovalle.net/mxmaps/articles/articles/leaflet_municipios.html
 
 
# library("geojsonio")
# library("jsonlite")
 
 
         # Convert the topoJSON to spatial object
# tmpdir <- tempdir()
         # have to use RJSONIO or else the topojson isn't valid
# write(RJSONIO::toJSON(mxstate.topoJSON), file.path(tmpdir, "mun.topojson"))
# muns <- topojson_read(file.path(tmpdir, "mun.topojson"))
 
# leaflet(muns) %>%
#   addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 0.1,
#               color = "green"
#   ) %>%
#   addProviderTiles("CartoDB.Positron")
 
 #######
 #######
 
#Base de datos para obtener las coordenadas geográficas de cada municipio
#Esta base de datos fue trabajada por Conabio
 
Mex <- read.delim("data/Z_NACIONAL.csv"  , header = T, sep = ",")

Mex$CVE_MUN <- sprintf("%03d", Mex$CVE_MUN)
Mex$CVE_EDO <- sprintf("%02d", Mex$CVE_EDO)

head(Mex)
str(Mex)
Mex1 <- Mex %>%
  unite(Region, CVE_EDO, CVE_MUN, sep = "") %>%
  filter(CVE_LOC == 1) %>%
  select(NOM_ENT, NOM_MUN, lon_dd, lat_dd, Region, ALTITUD) %>%
  dplyr::rename(Estado = NOM_ENT) %>%
  dplyr::rename(lng = lon_dd) %>%
  dplyr::rename(lat = lat_dd)

#######
#Base de datos de Marighuana y Amapola entregada por el Ejercito
getwd()
setwd("~/Dropbox/GitHub/DrugsMx/")

Tabla1 <- read.delim("data/MagnaBase_060818.csv", sep = ",", header = T)
dim(Tabla1)

names(Tabla1)

#Ahora para Marihuana
#Hectáreas

Tabla2 <- Tabla1 %>%
  select(ID, matches("mari")) %>%
  select(ID, matches("has")) %>%
  dplyr::rename(Region = ID) %>%
  tidyr::gather("Cultivo", "Hectáreas", -1) %>%
  separate(Cultivo, c("Cultivo", "Año"), sep = 9) %>%
  separate(Cultivo, c("Variable", "Cultivo")) %>%
  select(-Variable)
#filter(plan_marih16 >= 1)
head(Tabla2)

#Para los plantios
Tabla2.1 <- Tabla1 %>%
  select(ID, matches("mari")) %>%
  select(ID, matches("plan")) %>%
  dplyr::rename(Region = ID) %>%
  tidyr::gather("Cultivo", "Plantíos", -1) %>%
  separate(Cultivo, c("Cultivo", "Año"), sep = 10) %>%
  separate(Cultivo, c("Variable", "Cultivo")) %>%
  select(-Variable)
head(Tabla2.1)

Tabla2.2 <- dplyr::full_join(Tabla2, Tabla2.1, by = c("Region", "Cultivo", "Año"))
head(Tabla2.2)


#Para Amapola
#para las hectáreas 
Tabla3 <- Tabla1 %>%
  select(ID, matches("amap")) %>%
  select(ID, matches("has")) %>%
  dplyr::rename(Region = ID) %>%
  tidyr::gather("Cultivo", "Hectáreas", -1) %>%
  separate(Cultivo, c("Cultivo", "Año"), sep = 8) %>%
  separate(Cultivo, c("Variable", "Cultivo")) %>%
  select(-Variable)
#filter(plan_marih16 >= 1)
head(Tabla3)

#Para los plantios 
Tabla3.1 <- Tabla1 %>%
  select(ID, matches("amap")) %>%
  select(ID, matches("plan")) %>%
  dplyr::rename(Region = ID) %>%
  tidyr::gather("Cultivo", "Plantíos", -1) %>%
  separate(Cultivo, c("Cultivo", "Año"), sep = 9) %>%
  separate(Cultivo, c("Variable", "Cultivo")) %>%
  select(-Variable)

head(Tabla3.1)

Tabla3.3 <- dplyr::full_join(Tabla3, Tabla3.1, by = c("Region", "Cultivo", "Año"))

TablaFF <- dplyr::union(Tabla2.2, Tabla3.3)
head(TablaFF)
str(TablaFF)
TablaFF$Region <- as.character(sprintf("%05d", TablaFF$Region))
TablaFF$Cultivo <- as.factor(TablaFF$Cultivo)
TablaFF$Año <- as.factor(TablaFF$Año)
TablaFF <- TablaFF %>%
  dplyr::mutate(Cultivo = recode(Cultivo,"amap" = "Amapola")) %>%
  dplyr::mutate(Cultivo = recode(Cultivo,"marih" = "Marihuana")) %>%
  dplyr::mutate(Año = recode(Año,"05" = "2005")) %>%
  dplyr::mutate(Año = recode(Año,"06" = "2006")) %>%
  dplyr::mutate(Año = recode(Año,"07" = "2007")) %>%
  dplyr::mutate(Año = recode(Año,"08" = "2008")) %>%
  dplyr::mutate(Año = recode(Año,"09" = "2009")) %>%
  dplyr::mutate(Año = recode(Año,"10" = "2010")) %>%
  dplyr::mutate(Año = recode(Año,"11" = "2011")) %>%
  dplyr::mutate(Año = recode(Año,"12" = "2012")) %>%
  dplyr::mutate(Año = recode(Año,"13" = "2013")) %>%
  dplyr::mutate(Año = recode(Año,"14" = "2014")) %>%
  dplyr::mutate(Año = recode(Año,"15" = "2015")) %>%
  dplyr::mutate(Año = recode(Año,"16" = "2016")) %>%
  dplyr::mutate(Año = recode(Año,"17" = "2017")) %>%
  dplyr::mutate(Año = recode(Año,"05" = "2005")) %>%
  dplyr::mutate(Año = recode(Año,"05" = "2005")) %>%
  na.omit(Plantíos) %>%
  dplyr::left_join(Mex1, by = "Region") %>%
  na.omit(Estado)


##### esta parte falta meterla en el shiny
#str(TablaFF)
head(TablaFF)
summary(TablaFF)

TablaFF1 <- TablaFF %>%
  filter(Estado == "Guerrero")

head(TablaFF1)

ggplot(TablaFF1, aes(x = Plantíos, y = ALTITUD)) +
  geom_point(size = 1)


#Maíz
dim(Tabla1)
names(Tabla1)
#para las hectáreas 
Tabla4 <- Tabla1 %>%
  select(ID, matches("area_harvested")) %>%
  na.omit(ID) %>%
  tidyr::gather("Maíz", "MaizHa", -1) %>%
  separate(Maíz, c("Maíz", "Año"), sep = 14) %>%
  dplyr::mutate(Año = recode(Año,"05" = "2005")) %>%
  dplyr::mutate(Año = recode(Año,"06" = "2006")) %>%
  dplyr::mutate(Año = recode(Año,"07" = "2007")) %>%
  dplyr::mutate(Año = recode(Año,"08" = "2008")) %>%
  dplyr::mutate(Año = recode(Año,"09" = "2009")) %>%
  dplyr::mutate(Año = recode(Año,"10" = "2010")) %>%
  dplyr::mutate(Año = recode(Año,"11" = "2011")) %>%
  dplyr::mutate(Año = recode(Año,"12" = "2012")) %>%
  dplyr::mutate(Año = recode(Año,"13" = "2013")) %>%
  dplyr::mutate(Año = recode(Año,"14" = "2014")) %>%
  dplyr::mutate(Año = recode(Año,"15" = "2015")) %>%
  dplyr::rename(Region = ID)
  
Tabla4$Region <- as.character(sprintf("%05d", Tabla4$Region))
Tabla4$Año <- as.factor(Tabla4$Año)

head(Tabla4)
head(TablaFF)
tail(Tabla4, 70)
levels(TablaFF$Estado)
str(Tabla4)
str(TablaFF)

dim(TablaFF)
Tabla5 <- right_join(TablaFF, Tabla4, by = c("Region","Año")) %>%
  filter(Hectáreas > 0) %>%
  filter(Estado == "Puebla")



ggplot(Tabla5, aes(x = log(Hectáreas), y = log(MaizHa), color = Cultivo)) +
  geom_point(size = 1) +
  geom_smooth(method = "lm", se = F) +
  labs(title = "Nayarit", x = "Cultivo (Ha)", y = "Maíz (Ha)") +
  #guides(fill = guide_legend(title = "Cause of death")) +
  #coord_flip() +
  theme_bw()


dim(Tabla5)
head(Tabla5)

Tabla4.1 <- Tabla1 %>%
  select(ID, matches("yield")) 

Tabla4.2 <- Tabla1 %>%
  select(ID, matches("area_harvested")) %>%
  dplyr::rename(Region = ID) %>%
  tidyr::gather("Hectáreas", "Value", -1) %>%
  separate(Hectáreas, c("Hectáreas", "Año"), sep = 14)
  separate(Cultivo, c("Variable", "Cultivo")) %>%
  select(-Variable)

head(Tabla4.2)

Tabla4 <- inner_join(Tabla4, Tabla4.1, by = "ID") %>%
  distinct()
Tabla4 <- inner_join(Tabla4, Tabla4.2, by = "ID") %>%
  distinct()


head(Tabla4)
  select(ID, matches("has")) %>%
  dplyr::rename(Region = ID) %>%
  tidyr::gather("Cultivo", "Hectáreas", -1) %>%
  separate(Cultivo, c("Cultivo", "Año"), sep = 8) %>%
  separate(Cultivo, c("Variable", "Cultivo")) %>%
  select(-Variable)
#filter(plan_marih16 >= 1)
head(Tabla3)

#Para los plantios 
Tabla3.1 <- Tabla1 %>%
  select(ID, matches("amap")) %>%
  select(ID, matches("plan")) %>%
  dplyr::rename(Region = ID) %>%
  tidyr::gather("Cultivo", "Plantíos", -1) %>%
  separate(Cultivo, c("Cultivo", "Año"), sep = 9) %>%
  separate(Cultivo, c("Variable", "Cultivo")) %>%
  select(-Variable)

head(Tabla3.1)

Tabla3.3 <- dplyr::full_join(Tabla3, Tabla3.1, by = c("Region", "Cultivo", "Año"))



#####



  
