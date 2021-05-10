
# Carregar pipe
library(magrittr, include.only = '%>%')


# Ler base ----------------------------------------------------------------
ssp_pivot_categorico <-readr::read_rds("./data/ssp_pivot_categorico.rds")
pop_sp <- readr::read_rds("./data/pop_sp.rds")

dplyr::glimpse(ssp_pivot_categorico)
dplyr::glimpse(pop_sp)

# Fazer join --------------------------------------------------------------

# corrigindo coluna de ano na base de pop
pop_sp <-
    pop_sp %>% 
    dplyr::mutate(ano = as.double(ano))

# adicionar a população para cada município
ssp_completo <-
    ssp_pivot_categorico %>% 
    dplyr::left_join(y = pop_sp) # join automático por ano e por municipio_nome

View(ssp_completo)

# confirmando se o join ficou 100%
ssp_completo %>%
    dplyr::filter(is.na(ocorrencias))


# Transformar dados -------------------------------------------------------

# O objetivo é fazer mapas por município/região, contudo, se eu usar a coluna
# de ocorrências do jeito que tá, obviamente as cidades mais populasas serão
# as que apontam mais crimes. Uma alternativa para isso é realizar uma ponderação
# para crimes a cada 100mil habitantes.
# Fonte: http://www.ssp.sp.gov.br/fale/estatisticas/answers.aspx?t=6

# Fazer ponderação para uma taxa de 100mil habitantes
ssp_completo_ponderado <-
    ssp_completo %>% 
    dplyr::mutate(pop_tx_100_mil_hab = (ocorrencias/pop)*100000)


# Exportar essa base
ssp_completo_ponderado %>% 
    saveRDS("./data/ssp_completo_ponderado.rds")
