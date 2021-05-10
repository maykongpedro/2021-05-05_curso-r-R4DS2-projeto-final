
# Carregar pipe
library(magrittr, include.only = '%>%')


# Ler base ----------------------------------------------------------------

# Base shape dos municípios de SP
# não quis funcionar
# base_muni_sp <-
#     geobr::read_municipality() %>%
#     dplyr::filter(abbrev_state == "SP")


# Base shape com todos os municípios
base_muni <- readr::read_rds("./data/municipios_todos.rds")

# Filtrando apenas SP
base_muni_sp <-
    base_muni %>% 
    dplyr::filter(abbrev_state == "SP")

base_muni_sp


# Exportar shape
base_muni_sp %>% 
    saveRDS("./data/base_muni_sp.rds")
