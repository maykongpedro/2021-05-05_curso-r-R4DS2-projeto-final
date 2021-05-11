
# Carregar pipe
library(magrittr, include.only = '%>%')


# Ler base ----------------------------------------------------------------

# base dos joins
ssp_comp_ponderado <- readr::read_rds("./data/ssp_completo_ponderado.rds")

dplyr::glimpse(ssp_comp_ponderado)


# base shape
base_muni <- readr::read_rds("./data/base_muni_sp.rds")
dplyr::glimpse(base_muni)


# base para plot
library(sf) # precisei carregar o sf pra poder fazer o join


# Quantidade de municípios na base
municipios_total <- 
    ssp_comp_ponderado %>% 
    dplyr::filter(ano == 2019) %>%       # apenas 2019
    dplyr::distinct(municipio_nome) %>% 
    dplyr::count()
municipios_total  
    

# Quantos municípios tem população acima de 100mil habitantes?
municipios_100mil <- 
    ssp_comp_ponderado %>% 
    dplyr::filter(ano == 2019,       # apenas 2019
                  pop >= 100000) %>% # população igual ou acima de 100mil
    dplyr::distinct(municipio_nome) %>% 
    dplyr::count()
municipios_100mil 



# filtrando apenas ano de 2019 para não ficar pesado
ssp_comp_ponderado_2019 <- 
    ssp_comp_ponderado %>% 
    dplyr::filter(ano == 2019,       # apenas 2019
                  pop >= 100000) %>% # população igual ou acima de 100mil
    dplyr::select(municipio_nome, 
                  codigo_ibge, 
                  crime_cometido,
                  ocorrencias,
                  categoria,
                  pop_tx_100_mil_hab)
    
    
    

# fazendo sumarização sem categoria
ssp2019_taxas_geral <- 
    ssp_comp_ponderado_2019 %>% 
    dplyr::group_by(municipio_nome, codigo_ibge) %>% 
    dplyr::summarise(total_tx = sum(pop_tx_100_mil_hab)) %>% 
    dplyr::ungroup()


ssp2019_taxas_categoria <-
    ssp_comp_ponderado_2019 %>% 
    dplyr::group_by(municipio_nome, codigo_ibge, categoria) %>% 
    dplyr::summarise(total_tx = sum(pop_tx_100_mil_hab)) %>% 
    dplyr::ungroup()    


# Fazer join com o shape (sem categoria)
ssp_2019_shp_tx_geral <-
    base_muni %>% # necessário usar o shape como primeiro argumento
    dplyr::left_join(y = ssp2019_taxas_geral, by = c("code_muni" = "codigo_ibge")) %>% 
    dplyr::select(-municipio_nome) # retirar coluna duplicada

# Exportar essa base
ssp_2019_shp_tx_geral %>% 
    saveRDS("./data/ssp_2019_shp_tx_geral.rds")

# Fazer join com o shape (com categorias de crimes)
ssp_2019_shp_tx_categoria <-
    base_muni %>% # necessário usar o shape como primeiro argumento
    dplyr::left_join(y = ssp2019_taxas_categoria, by = c("code_muni" = "codigo_ibge")) %>% 
    dplyr::select(-municipio_nome) # retirar coluna duplicada

# Exportar essa base
ssp_2019_shp_tx_categoria %>% 
    saveRDS("./data/ssp_2019_shp_tx_categoria.rds")

# Mapas -------------------------------------------------------------------

# Para fazer os mapas usei de base o ótimo post da Bea (CursoR):
# https://beatrizmilz.com/posts/2020-07-27-criando-mapas-com-os-pacotes-tidyverse-e-geobr/


#  Distribuição das categorias de crimes por taxa de 100mil habitante

source("./R/3-ggplot-sf-mapa-municipios.R",encoding = "UTF-8")
mapa_geral <-
    ssp_2019_shp_tx_geral %>%  
    dplyr::filter(!is.na(total_tx)) %>% 
    
    mapa_municipios(shape_geral = base_muni,
                    valores = total_tx,
                    titulo = "Distribuição geográfica de ocorrências de crimes no estado de São Paulo em 2019",
                    subtitulo = "*Apenas cidades com mais de 100mil habitantes - Todos as categorias de crimes*")


source("./R/4-ggplot-sf-mapa-municipios-facet.R",encoding = "UTF-8")
mapa_categorias <- 
    ssp_2019_shp_tx_categoria %>%  
    dplyr::filter(!is.na(total_tx)) %>% 
    
    mapa_municipios_facet(shape_geral = base_muni,
                          valores = total_tx,
                          facet_grupos = categoria,
                          titulo = "Distribuição geográfica de ocorrências de crimes no estado de São Paulo em 2019",
                          subtitulo = "*Apenas cidades com mais de 100mil habitantes - Dividido em categorias de crimes*"
    )



# Salvando gráficos -------------------------------------------------------

ggplot2::ggsave(
        plot = mapa_geral,
        "./docs/mapa_geral.png",
        width = 24,
        height = 15,
        units = "cm",
        dpi = 300
    )

ggplot2::ggsave(
    plot = mapa_categorias,
    "./docs/mapa_categorias.png",
    width = 24,
    height = 15,
    units = "cm",
    dpi = 300
)


# ggplot2::ggsave(plot = mapa_geral,
#                 path = "./docs",
#                 filename = "mapa_geral_cm.png",
#                 height = grid::unit(8, units = "cm"),
#                 width = grid::unit(12, units = "cm"))
