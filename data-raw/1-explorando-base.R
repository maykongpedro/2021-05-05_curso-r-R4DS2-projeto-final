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
            stringr::str_detect(crime_cometido, "lesao") ~ "lesão_corporal",
            stringr::str_detect(crime_cometido, "latro") ~ "latrocinio",
            stringr::str_detect(crime_cometido, "roubo") ~ "roubo",
            TRUE ~ crime_cometido
    ))



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
nota_rodape <- "Dataviz: @maykongpedro | Fonte: SSP (Dados organizados pela Curso-R)"
eixo_x_breaks <- seq(from = 2002, to = 2019, by = 1)


ssp_pivot_categorico %>% 
    dplyr::filter(ano != 2020) %>% 
    dplyr::group_by(ano, categoria) %>% 
    dplyr::summarise(total_mil = sum(ocorrencias)/1000) %>% 
    
    ggplot2::ggplot() +
    ggplot2::geom_col(ggplot2::aes(x = ano, y = total_mil, fill = categoria)) +
    ggplot2::scale_x_continuous(breaks = eixo_x) +
    ggplot2::scale_y_continuous(expand = ggplot2::expansion(),
                                limits = c(0, 1300)) +
    ggplot2::scale_fill_viridis_d(direction = -1) +
    ggplot2::labs(x = "Ano", y = "Total de ocorrências (Mil)", 
                  fill = "Categoria de crime", 
                  caption = nota_rodape) +
    ggplot2::ggtitle("Histórico de ocorrências por categoria de crime no estado de São Paulo (Mil)") +
    ggplot2::theme_minimal() +
    ggplot2::theme(plot.title = ggplot2::element_text(face = "bold", hjust = 0.5),
                   axis.line.x = ggplot2::element_line(size = 1),
                   plot.caption = ggplot2::element_text(hjust = 1.5),
                   plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm"))



# Criminalidade aumentou da quarentena para cá? (Mar/2020)
# comparar com soma de ocorrências dos anos anteriores
# Como a base vai somente até abril de 2020, vou selecionar apenas os 4 meses
# iniciais de cada ano para poder fazer o comparativo
eixo_x_breaks <- seq(from = 2002, to = 2020, by = 1)
ssp_pivot_categorico %>% 
    dplyr::filter(mes %in% c(1, 2, 3, 4)) %>% 
    dplyr::group_by(ano, categoria) %>% 
    dplyr::summarise(total_mil = sum(ocorrencias)/1000) %>% 
    
    ggplot2::ggplot() +
    ggplot2::geom_col(ggplot2::aes(x = ano, y = total_mil, fill = categoria)) +
    ggplot2::scale_x_continuous(breaks = eixo_x) +
    ggplot2::scale_y_continuous(expand = ggplot2::expansion()) +
    ggplot2::scale_fill_viridis_d(direction = -1) +
    ggplot2::labs(x = "Ano", y = "Total de ocorrências (Mil)", 
                  fill = "Categoria de crime", 
                  caption = nota_rodape) +
    ggplot2::ggtitle("Histórico ocorrências por categoria de crime no estado de São Paulo (Mil)") +
    ggplot2::theme_minimal() +
    ggplot2::theme(plot.title = ggplot2::element_text(face = "bold", hjust = 0.5),
                   axis.line.x = ggplot2::element_line(size = 1),
                   plot.caption = ggplot2::element_text(hjust = 1.5))







# Adicionar código do município IBGE
base_muni_sp <- 
    geobr::read_municipality() %>% 
    dplyr::filter(abbrev_state == "SP")

