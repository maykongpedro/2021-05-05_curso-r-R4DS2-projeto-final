#' grafico_de_linhas
#'
#' Descrição da função
#' 
#' @param db base de dados
#' @param x eixo x do gráfico
#' @param y eixo y do gráfico
#' @param cores divisão de cores/legendas do gráfico
#' @param breaks_eixo_x breaks que o eixo x deve ter
#' @param titulo título do gráfico
#' @param subtitulo subtítulo do gráfico
#' 
#' @return retorna um gráfico de linhas dentro do estilo proposto para a análise
#' 
grafico_de_linhas <- function(db, 
                              x, 
                              y, 
                              cores, 
                              breaks_eixo_x,
                              titulo, 
                              subtitulo) { 
    
    ggplot2::ggplot(data = db, ggplot2::aes(x = {{x}}, y = {{y}}, colour = {{cores}})) +
        ggplot2::geom_line(size = 1.2, show.legend = FALSE) +
        ggplot2::scale_x_continuous(breaks = breaks_eixo_x) +
        ggplot2::scale_y_continuous(limits = c(0, 1000)) +
        ggplot2::scale_colour_viridis_d(direction = -1, begin = .2, end = .7) +
        directlabels::geom_dl(ggplot2::aes(label = {{cores}}), method = "smart.grid") +
        ggplot2::labs(x = "Ano", y = "Total de ocorrências (Mil)", 
                      subtitle = subtitulo,
                      caption = "Dataviz: @maykongpedro | Fonte: SSP (Dados organizados pela Curso-R)") +
        ggplot2::ggtitle(titulo) +
        ggplot2::theme_minimal() +
        ggplot2::theme(plot.title = ggplot2::element_text(face = "bold", hjust = 0.5),
                       plot.subtitle = ggplot2::element_text(hjust = 0.5),
                       axis.line.x = ggplot2::element_line(size = 1),
                       plot.caption = ggplot2::element_text(hjust = 1),
                       plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm"))
    
}
