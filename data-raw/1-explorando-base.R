# Carregar pipe
library(magrittr, include.only = '%>%')

# Motivações:
# Principais características  
# - Séries temporais  
# - Dados geográficos  
# - Oportunidade para construção de mapas  

# Sugestões de análises  
# - Visualizar as séries de criminalidade  
# - Avaliar se os níveis de criminalidade mudaram durante a quarentena  


# Ler base ----------------------------------------------------------------
ssp <- readr::read_rds("./data/ssp.rds")


# Explorar base -----------------------------------------------------------

# Ver a base
View(ssp)

# Olhar colunas e tipos
dplyr::glimpse(ssp)

# Qual o perídoo histórico da base
unique(ssp$ano)
    

# Transformar e Explorar  -------------------------------------------------


# Agrupando todos os crimes em apenas uma coluna
ssp_pivot <- 
    ssp %>%
    tidyr::pivot_longer(cols = 6:ncol(ssp),
                        names_to = "crime_cometido",
                        values_to = "ocorrencias")

# Confirmando se tem NA dentro da ocorrências
ssp_pivot %>% 
    dplyr::filter(is.na(ocorrencias))



# Quantos crimes temos dentro da base
ssp_pivot %>% 
    dplyr::select(crime_cometido) %>% 
    dplyr::distinct() %>% 
    dplyr::count()


# Qual o crime mais cometido dentro dessa base histórica?
ssp_pivot %>% 
    dplyr::group_by(crime_cometido) %>% 
    dplyr::summarise(quantidade_total = sum(ocorrencias)) %>% 
    dplyr::arrange(dplyr::desc(quantidade_total))


# Crimes cometidos por ano
ssp_pivot %>% 
    dplyr::group_by(ano, crime_cometido) %>% 
    dplyr::summarise(quantidade_total = sum(ocorrencias)) %>% 
    dplyr::arrange(ano,dplyr::desc(quantidade_total))




# Converter meses númericos para mês data




# Criminalidade aumentou da quarentena para cá? (Mar/2020)
# comparar com soma de ocorrências dos anos anteriores



# Adicionar código do município IBGE




