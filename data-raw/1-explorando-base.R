
# Carregar pipe
library(magrittr, include.only = '%>%')

# Motivações:
# Principais características  
# Visualizar série de criminalidade
# Categorizar e resumir principais crimes
# Comparar período de pandemia com a série histórica


# Ler base ----------------------------------------------------------------
ssp <- readr::read_rds("./data/ssp.rds")

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
    # gerando coluna de crimes_cometidos com as devidas ocorrências
    tidyr::pivot_longer(cols = 6:ncol(ssp),
                        names_to = "crime_cometido",
                        values_to = "ocorrencias") %>% 
    
    # retirando vítimas dos crimes
    dplyr::filter(!stringr::str_detect(crime_cometido, "vit")) %>% 
    
    # retirando "totais" para não atrapalhar na sumarização
    # se retiro os "totais", chego em erro pois tem ano onde a soma dos itens 
    # é zerada mas o "total" não
    #dplyr::filter(!stringr::str_detect(crime_cometido, "total"))
    
    # tirando crimes que são agrupadas em um total
    dplyr::filter(!(crime_cometido %in% c("estupro", 
                                          "estupro_vulneravel",
                                          "roubo_banco",
                                          "roubo_carga",
                                          "roubo_outros",
                                          "roubo_veiculo")))

# Confirmando se tem NA dentro de algum lugar da base



# Quantos crimes diferentes temos dentro da base
# (retirei crimes de estupro e roubo que não estavam agrupados no total)
n_crimes <-
    ssp_pivot %>% 
    dplyr::select(crime_cometido) %>% 
    dplyr::distinct() %>% 
    dplyr::count()
n_crimes


# Gerar uma categoria simplificada para os crimes
ssp_pivot_categorico <-
    ssp_pivot %>%
    dplyr::mutate(
        categoria = dplyr::case_when(
            stringr::str_detect(crime_cometido, "estupro") ~ "estupro",
            stringr::str_detect(crime_cometido, "furto") ~ "furto",
            stringr::str_detect(crime_cometido, "hom") ~ "homicido",
            stringr::str_detect(crime_cometido, "lesao") ~ "lesão corporal",
            stringr::str_detect(crime_cometido, "latro") ~ "latrocinio",
            stringr::str_detect(crime_cometido, "roubo") ~ "roubo",
            TRUE ~ crime_cometido
    ))

# Exportar essa base
ssp_pivot_categorico %>% 
    saveRDS("./data/ssp_pivot_categorico.rds")


# Qual o crime mais cometido dentro dessa base histórica?
ssp_pivot_categorico %>% 
    dplyr::group_by(crime_cometido) %>% 
    dplyr::summarise(total = sum(ocorrencias)) %>% 
    dplyr::arrange(dplyr::desc(total)) %>% 
    View()


# Qual a categoria de crime mais cometida?
ssp_pivot_categorico %>% 
    dplyr::group_by(categoria) %>% 
    dplyr::summarise(total = sum(ocorrencias)) %>% 
    dplyr::arrange(dplyr::desc(total))


# Categorias de crimes cometidos por ano
# aqui encontrei um erro, diz que não ocorreu nenhum estupro em 2002, então
# voltei nas colunas de totais e encontro dentr dela valores. A partir disso,
# resolvi deixar a coluna total dentro da base

ssp_pivot_categorico %>% 
    dplyr::group_by(ano, categoria) %>% 
    dplyr::summarise(total = sum(ocorrencias)) %>% 
    dplyr::arrange(ano,dplyr::desc(total))


# Quantidade total de crimes por ano excluindo 2020 (pois só tem até abril)
source("./R/1-ggplot-grafico-de-barras.R")
ssp_pivot_categorico %>% 
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
    

# Exibindo as categorias com mais de 50mil ocorrências
source("./R/2-ggplot-grafico-de-linhas.R")
ssp_pivot_categorico %>% 
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
    


# Criminalidade aumentou da quarentena para cá? (Mar/2020)
# comparar com soma de ocorrências dos anos anteriores
# Como a base vai somente até abril de 2020, vou selecionar apenas os 4 meses
# iniciais de cada ano para poder fazer o comparativo
ssp_pivot_categorico %>% 
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
