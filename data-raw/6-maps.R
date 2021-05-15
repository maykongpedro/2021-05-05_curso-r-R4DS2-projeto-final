
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


# Calculando as cidades com maiores ocorrências
ssp_pivot_categorico_tx <- readr::read_rds("./data/ssp_completo_ponderado.rds")
dplyr::glimpse(ssp_pivot_categorico_tx)

municipios_expressivos <-
    ssp_pivot_categorico_tx %>% 
    dplyr::filter(ano != 2020,
                  pop >= 100000) %>% 
    dplyr::group_by(municipio_nome, codigo_ibge) %>%
    dplyr::summarise(total_mil = sum(ocorrencias/1000)) %>% 
    dplyr::arrange(dplyr::desc(total_mil))
municipios_expressivos


municipios_expressivos_categorizado <-
    ssp_pivot_categorico_tx %>% 
    dplyr::filter(ano != 2020,
                  pop >= 100000) %>% 
    dplyr::group_by(municipio_nome, codigo_ibge, categoria) %>%
    dplyr::summarise(total_mil = sum(ocorrencias/1000)) %>% 
    dplyr::arrange(dplyr::desc(total_mil))

municipios_expressivos_categorizado

# Fazendo joins com o shape -----------------------------------------------
library(sf) # precisei carregar o sf pra poder fazer o join

ssp_shp_tx_geral <-
    base_muni %>% # necessário usar o shape como primeiro argumento
    dplyr::left_join(y = municipios_expressivos, by = c("code_muni" = "codigo_ibge")) %>% 
    dplyr::select(-municipio_nome) # retirar coluna duplicada


ssp_shp_tx_categorico <-
    base_muni %>% # necessário usar o shape como primeiro argumento
    dplyr::left_join(y = municipios_expressivos_categorizado, 
                     by = c("code_muni" = "codigo_ibge")) %>% 
    dplyr::select(-municipio_nome) # retirar coluna duplicada


# Mapas -------------------------------------------------------------------

# Para fazer os mapas usei de base o ótimo post da Bea (CursoR):
# https://beatrizmilz.com/posts/2020-07-27-criando-mapas-com-os-pacotes-tidyverse-e-geobr/

# ====================================================================
#  Cidades com maior taxa de crime por 100mil habitantes
# ====================================================================
ssp_shp_tx_geral %>% dplyr::glimpse()
source("./R/5-ggplot-sf-mapa-municipios.R",encoding = "UTF-8")
divisao_valores <- c(0, 200, 400, 600, 800, 1000,7000, 8000)

mapa_geral <-
    ssp_shp_tx_geral %>%  
    dplyr::filter(!is.na(total_mil)) %>% 
    
    # add coluna para label - apenas cidades com mais de 400.000 na taxa de crimes
    dplyr::mutate(label_muni = dplyr::case_when(total_mil > 400 ~ name_muni,
                                                TRUE ~ "NA"),
                  label_muni = ifelse(label_muni == "NA", NA, label_muni)) %>% 

    # add categoria de taxas, mais fácil de visualizar do que valores contínuos
    dplyr::mutate(total_mil = cut(total_mil, 
                                  c(divisao_valores), 
                                  dig.lab = 4))

plot_map_geral <- 
    mapa_geral %>% 
    mapa_municipios(shape_geral = base_muni,
                    valores = total_mil,
                    titulo = "Distribuição geográfica das cidades com maiores taxas de crime por 100mil hab.",
                    subtitulo = "Apenas cidades com no mínimo 100mil hab.") 

plot_map <- 
    plot_map_geral +
    ggrepel::geom_text_repel(data = mapa_geral,
        ggplot2::aes(label = label_muni, geometry = geom),
        stat = "sf_coordinates",
        force = 1, 
        nudge_x = c(5, -4, 2),
        size = 3,
        
        )
        #seed = 10) 

plot_map


    


# ====================================================================
#  Distribuição das categorias de crimes por taxa de 100mil habitantes
# ====================================================================
source("./R/6-ggplot-sf-mapa-municipios-facet.R",encoding = "UTF-8")
mapa_categorias <- 
    ssp_shp_tx_categorico %>%  
    dplyr::filter(!is.na(total_mil)) %>% 
    
    mapa_municipios_facet(shape_geral = base_muni,
                          valores = total_mil,
                          facet_grupos = categoria,
                          titulo = "Distribuição geográfica de ocorrências de crimes no estado de São Paulo em 2019",
                          subtitulo = "*Apenas cidades com mais de 100mil habitantes - Dividido em categorias de crimes*"
    )

mapa_categorias

# Não agregou muita coisa esse último gráfico, queria confirmar se havia alguma
# diferença significativa entre os tipos de crimes x localidade, mas basicamente
# segue o mesmo padrão do primeiro gráfico. Então nem colocarei no README.


# Salvando gráficos -------------------------------------------------------

ggplot2::ggsave(
        plot = plot_map,
        "./inst/mapa_geral.png",
        width = 24,
        height = 15,
        units = "cm",
        dpi = 300
    )
