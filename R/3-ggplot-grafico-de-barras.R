#' grafico_de_barras
#'
#' Descrição da função
#' 
#' @param db base de dados
#' @param x eixo x do gráfico
#' @param y eixo y do gráfico
#' @param preenchimento divisão de cores/legendas do gráfico
#' @param breaks_eixo_x breaks que o eixo x deve ter
#' @param titulo título do gráfico
#' @param subtitulo subtítulo do gráfico
#' @param tit_legenda título da legenda
#' 
#' @return retorna um gráfico de barras dentro do estilo proposto para a análise
#' 
grafico_de_barras <- function(db, 
                              x, 
                              y, 
                              preenchimento, 
                              breaks_eixo_x,
                              titulo, 
                              subtitulo, 
                              tit_legenda) { 
    
    ggplot2::ggplot() +
        ggplot2::geom_col(ggplot2::aes(x = total_mil, y = mes_name),
                          fill = ifelse(meses$mes_name != mes_maior_ocorrencias$mes_name,
                                        "#dfe0df",
                                        "#443A83")) +
        ggplot2::scale_x_continuous(expand = ggplot2::expansion(), 
                                    limits = c(0, mes_maior_ocorrencias$total_mil + 100)) +
        ggplot2::geom_label(
            ggplot2::aes(
                x = total_mil,
                y = mes_name ,
                label = mes_name_label,
                hjust = 1.2
            )) +
        ggplot2::labs(x = "Taxa de ocorrências por 100 mil habitantes", y = "", 
                      subtitle = "2002 a 2019 - Apenas cidades com no mínimo 100mil hab.",
                      caption = "**Dataviz:** @maykongpedro | **Fonte:** SSP (Dados organizados pela Curso-R)") +
        ggplot2::ggtitle("Mês que apresentou maior taxa de ocorrências de crime no estado de São Paulo") +
        ggplot2::theme_minimal() +
        ggplot2::theme(plot.title = ggplot2::element_text(face = "bold", hjust = 0.5),
                       plot.subtitle = ggplot2::element_text(hjust = 0.5),
                       axis.line.y = ggplot2::element_line(size = 1),
                       axis.text.x = ggplot2::element_blank(),
                       plot.caption = ggtext::element_markdown(hjust = 1),
                       plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm"))
    
}
