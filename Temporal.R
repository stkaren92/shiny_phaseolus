##Para la página de internet
#
#head(Mex4)
#
#
#head(Mex6)
#ggplot(Mex6) + 
#  geom_dumbbell(aes(x = minimo, xend = maximo, y = reorder(Especie, prom)),
#                colour = "#dddddd",
#                size = 1,
#                colour_x = "#FAAB18",
#                colour_xend = "#1380A1",
#                dot_guide = T,
#                dot_guide_size = 0.05) +
#  theme_minimal() +
#  theme(legend.position = "", 
#        axis.text.x = element_text(angle = 0, size = 8, hjust = 1, vjust = 0),
#        axis.text.y = element_text(size = 8, face = "italic"), 
#        axis.title = element_text(size = 11), 
#        legend.text = element_text(size = 11)) +
#  labs(title = "Altitud", x = "metros", 
#       y = "", fill = "",
#       family = "Helvetica") +
#  xlim(0, 4000)
##coord_flip()


#Para Floración y Fructificación
#FloFru <- read_xlsx("data/Flor_fruc.xlsx", sheet = "Rdata", col_names = T)
#
#head(FloFru)
#dim(FloFru)
#
#
#FloFru1 <- FloFru %>%
#  gather("Mes", "Val", 8:19) %>%
#  rename("Categoria" = "NombreCategoriaTaxonomica") %>% 
#  rename("Genero1" = "Nombre_1_Nombre") %>% 
#  rename("Especie1" = "Nombre_Nombre") %>% 
#  group_by(Genero1, Especie1, Mes) %>% 
#  summarise(sum(Val)) %>% 
#  rename(Val = `sum(Val)`) %>% 
#  unite(Genero1, Especie1, col = "Especie", sep = " ")
#
#FloFru1$Mes <- as.factor(FloFru1$Mes)
#
#FloFru1$Mes <- ordered(FloFru1$Mes, levels = c("Enero", "Febrero", "Marzo",
#                                              "Abril", "Mayo", "Junio",
#                                              "Julio", "Agosto", "Septiembre",
#                                              "Octubre", "Noviembre", "Diciembre"))
#
#
#p <- ggplot(FloFru1, aes(Mes, Especie)) + 
#  geom_tile(aes(fill = Val), colour = "white") + 
#  scale_fill_gradient(low = "#deebf7", high = "#3182bd") +
#  theme_minimal() +
#  theme(panel.border = element_blank(),
#        axis.text.y = element_text(size = 10, face = "italic"),
#        axis.text.x = element_text(angle = 45, size = 10, hjust = 0.2, vjust = 0.2),
#        legend.position = "")
#  
#p
#
#