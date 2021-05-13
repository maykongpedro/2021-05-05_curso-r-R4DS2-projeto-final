
# Carregar pipe
library(magrittr, include.only = '%>%')


# Motivações:
# Visualizar série de criminalidade
# Comparar período de pandemia com a série histórica


# Ler bases ---------------------------------------------------------------
ssp_pivot_categorico_tx <- readr::read_rds("./data/ssp_completo_ponderado.rds")
dplyr::glimpse(ssp_pivot_categorico_tx)


# Quanti. total de crimes por ano excluindo 2020 --------------------------
source("./R/1-ggplot-grafico-de-barras.R", encoding = "UTF-8")
plot1 <- 
    ssp_pivot_categorico_tx %>% 
    dplyr::filter(ano != 2020) %>% 
    dplyr::group_by(ano, categoria) %>% 
    dplyr::summarise(total_mil = sum(ocorrencias)/1000) %>% 
    
    grafico_de_barras(x = ano, 
                      y = total_mil, 
                      preenchimento = categoria,
                      breaks_eixo_x = seq(from = 2002, to = 2019, by = 1),
                      titulo = "Histórico de ocorrências por categoria de crime no estado de São Paulo (Mil ocorrências)",
                      subtitulo = NULL,
                      tit_legenda = "Categoria de crime")
plot1



# Histórico das categorias com mais de 50mil ocorrências ------------------
source("./R/2-ggplot-grafico-de-linhas.R", encoding = "UTF-8")
plot2 <-
    ssp_pivot_categorico_tx %>% 
    dplyr::filter(ano != 2020) %>% 
    dplyr::group_by(ano, categoria) %>% 
    dplyr::summarise(total_mil = sum(ocorrencias)/1000) %>% 
    dplyr::filter(total_mil > 50) %>%
    
    grafico_de_linhas(x = ano,
                      y = total_mil,
                      cores = categoria,
                      breaks_eixo_x = seq(from = 2002, to = 2019, by = 1),
                      titulo = "Histórico de ocorrências por categoria de crime no estado de São Paulo (Mil ocorrências)",
                      subtitulo = "Categorias com mais de 50mil ocorrências")
plot2




# Existe algum período do ano onde ocorrem mais crimes? -------------------

ssp_pivot_categorico_tx %>% 
    dplyr::filter(ano != 2020,
                  pop >= 100000) %>% 
    #dplyr::mutate(mes_abreviado = month.abb[mes]) %>% 
    dplyr::mutate(mes_name = month.name[mes]) %>% 
    dplyr::group_by(mes_name) %>% 
    dplyr::summarise(total_mil = sum(ocorrencias/1000)) %>% 
    dplyr::arrange(dplyr::desc(total_mil))



# Quais são as cidades com mais crimes dentro do histórico?
ssp_pivot_categorico_tx %>% 
    dplyr::filter(ano != 2020,
                  pop >= 100000) %>% 
    dplyr::group_by(municipio_nome) %>%
    dplyr::summarise(total_mil = sum(ocorrencias/1000),
                     populacao = mean(pop)/1000) %>% 
    dplyr::arrange(dplyr::desc(total_mil)) %>% 
    head(20)



# Criminalidade aumentou da quarentena para cá? (Mar/2020)
# comparar com soma de ocorrências dos anos anteriores
# Como a base vai somente até abril de 2020, vou selecionar apenas os 4 meses
# iniciais de cada ano para poder fazer o comparativo
plot4 <- 
    ssp_pivot_categorico_tx %>% 
    dplyr::filter(mes %in% c(1, 2, 3, 4)) %>% 
    dplyr::group_by(ano, categoria) %>% 
    dplyr::summarise(total_mil = sum(ocorrencias)/1000) %>% 
    
    grafico_de_barras(x = ano,
                      y = total_mil,
                      preenchimento = categoria,
                      breaks_eixo_x = seq(from = 2002, to = 2020, by = 1),
                      titulo = "Histórico de ocorrências por categoria de crime no estado de São Paulo (Mil ocorrências)",
                      subtitulo = "Apenas os 4 primeiros meses de cada ano",
                      tit_legenda = "Categoria de crime")


# obtendo máximo de 2020
total_2020 <-
    ssp_pivot_categorico_tx %>% 
    dplyr::filter(ano == 2020) %>% 
    dplyr::summarise(total = sum(ocorrencias/1000)) %>% 
    dplyr::pull()

# destacando a diferença
plot4 <- 
    plot4 + 
    # adicionar uma linha de corte
    ggplot2::geom_hline(yintercept=total_2020, linetype="dashed", color = "red", size = 1) +
    
    # adicionar rótulo
    ggplot2::geom_label(ggplot2::aes(x = 2009, y = total_2020, label = "Linha de corte de 2020"), 
               hjust = 0, 
               vjust = 0.5, 
               colour = "#1380A1", 
               fill = "white", 
               label.size = NA, 
               size = 3) 
plot4    




