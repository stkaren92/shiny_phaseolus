#Para la página de internet

head(Mex4)


head(Mex6)
ggplot(Mex6) + 
  geom_dumbbell(aes(x = minimo, xend = maximo, y = reorder(Especie, prom)),
                colour = "#dddddd",
                size = 1,
                colour_x = "#FAAB18",
                colour_xend = "#1380A1",
                dot_guide = T,
                dot_guide_size = 0.05) +
  theme_minimal() +
  theme(legend.position = "", 
        axis.text.x = element_text(angle = 0, size = 8, hjust = 1, vjust = 0),
        axis.text.y = element_text(size = 8, face = "italic"), 
        axis.title = element_text(size = 11), 
        legend.text = element_text(size = 11)) +
  labs(title = "Altitud", x = "metros", 
       y = "", fill = "",
       family = "Helvetica") +
  xlim(0, 4000)
#coord_flip()


#Para Floración y Fructificación
FloFru <- read_xlsx("data/Flor_fruc.xlsx", sheet = "Rdata", col_names = T)

head(FloFru)
dim(FloFru)


FloFru1 <- FloFru %>%
  gather("Mes", "Val", 8:19) %>%
  mutate(Mes1 = Mes) %>%
  dplyr::mutate(Mes1 = revalue(Mes1,c("Enero" = 1))) %>%
  dplyr::mutate(Mes1 = revalue(Mes1,c("Febrero" = 2))) %>%
  dplyr::mutate(Mes1 = revalue(Mes1,c("Marzo" = 3))) %>%
  dplyr::mutate(Mes1 = revalue(Mes1,c("Abril" = 4))) %>%
  dplyr::mutate(Mes1 = revalue(Mes1,c("Mayo" = 5))) %>%
  dplyr::mutate(Mes1 = revalue(Mes1,c("Junio" = 6))) %>%
  dplyr::mutate(Mes1 = revalue(Mes1,c("Julio" = 7))) %>%
  dplyr::mutate(Mes1 = revalue(Mes1,c("Agosto" = 8))) %>%
  dplyr::mutate(Mes1 = revalue(Mes1,c("Septiembre" = 9))) %>%
  dplyr::mutate(Mes1 = revalue(Mes1,c("Octubre" = 10))) %>%
  dplyr::mutate(Mes1 = revalue(Mes1,c("Noviembre" = 11))) %>%
  dplyr::mutate(Mes1 = revalue(Mes1,c("Diciembre" = 12))) %>% 
  rename("Categoria" = "NombreCategoriaTaxonomica") %>% 
  rename("Genero1" = "Nombre_1_Nombre") %>% 
  rename("Especie1" = "Nombre_Nombre") %>% 
  group_by(Genero1, Especie1, Tipo, Mes1, Mes) %>% 
  summarise(sum(Val)) %>% 
  rename(Val = `sum(Val)`)
#dplyr::mutate(Val = revalue(Val,c(1 = 100))) %>%
#filter(Tipo == "Cultivados") %>%
#filter(Epoca == "Fructificación") %>%
#filter(Val > 0)

names(FloFru1)
head(FloFru1)

dim(FloFru1)

FloFru1$Mes1 <- as.numeric(FloFru1$Mes1)

FloFru1$Especie1 <- as.factor(FloFru1$Especie1)

FloFru1[FloFru1$Especie1 == "coccineus",]

head(FloFru1)

library(ggridges)

ggplot(FloFru1, aes(x = Mes1, y = Especie1, fill = Especie1, height = ..density..)) + 
  geom_density_ridges(aes(y = Especie1), color = "red", fill = "red",
                      alpha = 0.5, scale = 1, jittered_points = F) +
  #scale_x_continuous(expand = c(-0.25,-0.25), breaks = c(1:12)) +
  theme_bw() +
  scale_x_discrete(breaks = c(1, 10, 11, 12, 2:9),
                   labels = c("Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul",
                              "Ags", "Sep", "Oct", "Nov", "Dic"))

ggplot(FloFru1, aes(x = Mes1, y = Val)) +
  theme_bw() +
  geom_line(aes(color = Especie1), size = 5, alpha = 0.5 ) +
  scale_x_discrete(breaks = c(1, 10, 11, 12, 2:9),
                   labels = c("Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", 
                              "Ags", "Sep", "Oct", "Nov", "Dic"))

scale_x_continuous(expand = c(0,0), breaks = c(1:12)) 



head(iris)
ggplot(iris, aes(x = Sepal.Length, y = Species)) + geom_density_ridges()

head(FloFru1)
