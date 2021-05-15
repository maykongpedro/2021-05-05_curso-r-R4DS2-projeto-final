#' grafico_de_evolução
#'
#' Descrição da função
#' 
#' @param db base de dados
#' @param x eixo x do gráfico
#' @param y eixo y do gráfico
#' @param destaque qual barra deve ser destacada
#' @param col_destaque coluna que contém os valores que serão usados para destaque
#' @param rotulos qual barra deve ser destacada
#' @param titulo título do gráfico
#' @param subtitulo subtítulo do gráfico
#' @param limite_valor limite dos valores do gráfico
#' 
#' @return retorna um gráfico de barras dentro do estilo proposto para a análise
#'
grafico_de_evolucao <- function(db,
                                x,
                                y,
                                destaque,
                                col_destaque,
                                rotulos,
                                titulo,
                                subtitulo,
                                limite_valor) {
    
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
    
}