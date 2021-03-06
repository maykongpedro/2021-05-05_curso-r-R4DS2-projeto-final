#' grafico_de_colunas
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
#' @return retorna um gráfico de colunas dentro do estilo proposto para a análise
#' 
grafico_de_colunas <- function(db, 
                              x, 
                              y, 
                              preenchimento, 
                              breaks_eixo_x,
                              titulo, 
                              subtitulo, 
                              tit_legenda) { 
 
        ggplot2::ggplot(data = db) +
        ggplot2::geom_col(ggplot2::aes(x = {{x}}, y = {{y}}, fill = {{preenchimento}})) +
        ggplot2::scale_x_continuous(breaks = breaks_eixo_x) +
        ggplot2::scale_y_continuous(expand = ggplot2::expansion()) +
        ggplot2::scale_fill_viridis_d(direction = 1) +
        ggplot2::labs(x = "Ano", y = "Total de ocorrências (Mil)", 
                      fill = tit_legenda, 
                      subtitle = subtitulo,
                      caption = "**Dataviz:** @maykongpedro | **Fonte:** SSP (Dados organizados pela Curso-R)") +
        ggplot2::ggtitle(titulo) +
        ggplot2::theme_minimal() +
        ggplot2::theme(plot.title = ggplot2::element_text(face = "bold", hjust = 0.5),
                       plot.subtitle = ggplot2::element_text(hjust = 0.5),
                       axis.line.x = ggplot2::element_line(size = 1),
                       plot.caption = ggtext::element_markdown(hjust = 1.5),
                       plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm"))
    
}
