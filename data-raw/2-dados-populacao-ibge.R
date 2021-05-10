
# # Carregar pipe
library(magrittr, include.only = '%>%')


# Ler arquivo -------------------------------------------------------------
pop_sp <- readxl::read_excel("./data-raw/ibge_populacao_municipios_sp.xlsx")



# Explorar dados ----------------------------------------------------------

View(pop_sp)
dplyr::glimpse(pop_sp)



# Transormar dados --------------------------------------------------------

pop_sp_pivot <-
    pop_sp %>% 
    tidyr::pivot_longer(cols = 3:ncol(pop_sp),
                        names_to = "ano",
                        values_to = "pop")

pop_sp_pivot



# Exportar dados ----------------------------------------------------------

pop_sp_pivot %>% 
    saveRDS("./data/pop_sp.rds")
