
# Carregar pipe
library(magrittr, include.only = '%>%')

# Motivações:
# Principais características  
# Categorizar e resumir principais crimes


# Ler base ----------------------------------------------------------------
ssp <- readr::read_rds("./data/ssp.rds")

# Ver a base
View(ssp)

# Olhar colunas e tipos
dplyr::glimpse(ssp)

# Qual o perídoo histórico da base
unique(ssp$ano)


# Transformar e Explorar  -------------------------------------------------

# visualizar quantos itens tem NA em cada coluna
ssp %>% 
    dplyr::summarise(
        dplyr::across(
            .cols = dplyr::everything(),
            .fns = ~sum(is.na(.x))
        )
    ) %>% 
    dplyr::select(
        where(~.x > 0)
    )

# verificando se existem ocorrências dentro desses NAs
ssp %>% 
    dplyr::filter(is.na(delegacia_nome)) %>%
    dplyr::summarise(
        dplyr::across(
            .cols = 6:ncol(ssp),
            .fns = ~ sum(.x)
            )
        ) %>% 
    View()
# Não existem ocorrências, então isso não vai atrapalhar na análise


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
            stringr::str_detect(crime_cometido, "hom") ~ "homicidio",
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
# voltei nas colunas de totais e encontro dentro dela valores. A partir disso,
# resolvi deixar a coluna total dentro da base

ssp_pivot_categorico %>% 
    dplyr::group_by(ano, categoria) %>% 
    dplyr::summarise(total = sum(ocorrencias)) %>% 
    dplyr::arrange(ano,dplyr::desc(total))


    



