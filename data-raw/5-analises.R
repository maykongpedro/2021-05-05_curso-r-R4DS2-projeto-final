
# Carregar pipe
library(magrittr, include.only = '%>%')


# Motivações:
# Visualizar série de criminalidade
# Comparar período de pandemia com a série histórica


# Ler bases ---------------------------------------------------------------
ssp_pivot_categorico_tx <- readr::read_rds("./data/ssp_completo_ponderado.rds")
dplyr::glimpse(ssp_pivot_categorico_tx)


# Quanti. total de crimes por ano excluindo 2020 --------------------------
source("./R/1-ggplot-grafico-de-colunas.R", encoding = "UTF-8")
plot1 <- 
    ssp_pivot_categorico_tx %>% 
    dplyr::filter(ano != 2020) %>% 
    dplyr::group_by(ano, categoria) %>% 
    dplyr::summarise(total_mil = sum(ocorrencias)/1000) %>% 
    
    grafico_de_colunas(x = ano, 
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
meses <- 
    ssp_pivot_categorico_tx %>% 
    dplyr::filter(ano != 2020,
                  pop >= 100000) %>% 
    #dplyr::mutate(mes_completo = month.name[mes]) %>% 
    dplyr::mutate(mes_name = month.abb[mes],
                  mes_name = forcats::fct_relevel(mes_name, month.abb)) %>% 
    dplyr::group_by(mes_name) %>% 
    dplyr::summarise(total_mil = sum(ocorrencias/1000))

# guardando o mes com maiores ocorrencias
mes_maior_ocorrencias <- 
    meses %>% 
    dplyr::filter(total_mil == max(total_mil))

                
# plotando meses
source("./R/3-ggplot-grafico-de-barras.R", encoding = "UTF-8")

plot_3 <- 
    meses %>% 
    dplyr::mutate(
        mes_name = forcats::fct_rev(mes_name), # invertendo ordem dos fatores
        mes_name_label = sprintf("%1.f Mil", round(total_mil, 0)) # criando labels
    ) %>% 
    grafico_de_barras(x = total_mil,
                      y = mes_name,
                      destaque = mes_maior_ocorrencias$mes_name,
                      col_destaque = "mes_name",
                      rotulos = mes_name_label,
                      titulo = "Mês que apresentou maior taxa de ocorrências de crime no estado de São Paulo",
                      subtitulo = "2002 a 2019 - Apenas cidades com no mínimo 100mil hab.",
                      limite_valor = mes_maior_ocorrencias$total_mil + 100)
    

plot_3


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
source("./R/1-ggplot-grafico-de-colunas.R.R", encoding = "UTF-8")
plot4 <- 
    ssp_pivot_categorico_tx %>% 
    dplyr::filter(mes %in% c(1, 2, 3, 4)) %>% 
    dplyr::group_by(ano, categoria) %>% 
    dplyr::summarise(total_mil = sum(ocorrencias)/1000) %>% 
    
    grafico_de_colunas(x = ano,
                      y = total_mil,
                      preenchimento = categoria,
                      breaks_eixo_x = seq(from = 2002, to = 2020, by = 1),
                      titulo = "Histórico de ocorrências por categoria de crime no estado de São Paulo (Mil ocorrências)",
                      subtitulo = "Apenas os 4 primeiros meses de cada ano",
                      tit_legenda = "Categoria de crime")

plot4

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


# gráfico de 1 ano entre 2019 e 2020
ano_covid <-
    ssp_pivot_categorico_tx %>% 
    dplyr::filter(ano %in% c(2019, 2020)) %>% 
    tidyr::unite(col = "data", c("mes", "ano"), sep = "/", remove = FALSE) %>% 
    dplyr::mutate(data = lubridate::my(data)) %>% 
    dplyr::filter(dplyr::between(data, 
                                 as.Date("2019-04-01"), 
                                 as.Date("2020-04-01"))) %>%
    dplyr::group_by(data) %>% 
    dplyr::summarise(total_mil = sum(ocorrencias/1000)) 
ano_covid


plot5 <- 
    ano_covid %>% 
    ggplot2::ggplot(ggplot2::aes(x = data, y = total_mil)) +
    ggplot2::geom_line(size = 1, color = "#440164") +
    ggplot2::geom_point(size = 4, color = "#440164") +
    ggplot2::geom_area(colour = "black", fill = "#31688e", alpha = .1) +
    ggplot2::scale_y_continuous(expand = ggplot2::expansion(), limits = c(0, 100)) +
    ggplot2::scale_x_date(breaks = "months", date_labels = "%b/%y") +
    ggplot2::labs(x = "", y = "Total de ocorrências (Mil)",
                  caption = "**Dataviz:** @maykongpedro | **Fonte:** SSP (Dados organizados pela Curso-R)") +
    ggplot2::ggtitle("Total de ocorrências de crimes dentro do período de um ano no estado de São Paulo") +
    ggplot2::theme_minimal() +
    ggplot2::theme(plot.title = ggplot2::element_text(face = "bold", hjust = 0.5),
                   plot.subtitle = ggplot2::element_text(hjust = 0.5),
                   axis.line.x = ggplot2::element_line(size = 1),
                   plot.caption = ggtext::element_markdown(hjust = 1),
                   plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm")) 
plot5

# percentual de diferença
abril_2019 <- ano_covid[1,2]
abril_2020 <- ano_covid[nrow(ano_covid), 2]    
percentual_dif <- round((abril_2020 - abril_2019)/abril_2019, 3)

percentual_dif


# data do primeiro caso de covid confirmado em SP
# https://especiais.g1.globo.com/sp/sao-paulo/2021/um-ano-de-covid-sp/
caso1_covid_sp <- as.Date("2020-02-26")


# add linhas e anotações
plot5_com_notas <-
    plot5 +
    
    ggplot2::geom_vline(xintercept=caso1_covid_sp, 
                        linetype="dashed", 
                        color = "#f39189", size = .5) +
    
    ggplot2::geom_label(
        ggplot2::aes(x = as.Date("2020-01-01"),
                     y = 25,
                     label = "Confirmação do primeiro caso de \nCOVID-19 no estado de São Paulo"),
        hjust = .7,
        colour = "#f39189",
        fill = NA,
        #label.size = NA,
        size = 3
    ) +
    
    ggplot2::geom_curve(ggplot2::aes(x = as.Date("2020-02-01"), 
                                     y = 25, 
                                     xend = as.Date("2020-02-23"), 
                                     yend = 27), 
                        colour = "#f39189", 
                        size=0.7, 
                        curvature = -0.1,
                        arrow = ggplot2::arrow(length = grid::unit(0.03, "npc"))) +
    
    ggplot2::geom_label(
        ggplot2::aes(x = as.Date("2020-04-01"),
                     y = 45,
                     label = scales::percent(percentual_dif$total_mil)),
        hjust = .4,
        colour = "#f39189",
        fill = NA,
        label.size = NA,
        size = 6
    ) +
    
    ggplot2::geom_label(
        ggplot2::aes(x = as.Date("2020-04-01"),
                     y = 36,
                     label = "Diminuição em \nrelação ao \nmesmo período \ndo ano anterior"),
        hjust = .57,
        colour = "#f39189",
        fill = NA,
        #label.size = NA,
        size = 3
    )
    
plot5_com_notas


# ggplot2::ggsave(
#     plot = plot5_com_notas,
#     "./inst/covid_mes.png",
#     width = 24,
#     height = 15,
#     units = "cm",
#     dpi = 300
# )


# Salvar gráficos ---------------------------------------------------------

graficos_finais <- list(
    hist_ocorrencias_ate_2019 = plot1,
    hist_ocorrencias_mais_expressivas = plot2,
    mes_mais_violento = plot_3,
    hist_quadrimestre_covid = plot4,
    hist_ano_covid = plot5_com_notas
)


purrr::iwalk(graficos_finais, ~ggplot2::ggsave(paste0(.y, ".png"), .x, 
                                               path = "./inst",
                                               height = 15,
                                               width = 24,
                                               units = "cm",
                                               dpi = 300))


