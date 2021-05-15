#' grafico_de_barras
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
grafico_de_barras <- function(db, 
                              x, 
                              y, 
                              destaque,
                              col_destaque,
                              rotulos,
                              titulo, 
                              subtitulo, 
                              limite_valor) { 
    
    ggplot2::ggplot() +
        ggplot2::geom_col(data = db, ggplot2::aes(x = {{x}}, y = {{y}}),
                          fill = ifelse(db[[col_destaque]] != destaque,
                                        "#dfe0df",
                                        "#443A83")) +
        ggplot2::scale_x_continuous(expand = ggplot2::expansion(), 
                                    limits = c(0, limite_valor)) +
        ggplot2::geom_label(data = db,
            ggplot2::aes(
                x = {{x}},
                y = {{y}} ,
                label = {{rotulos}},
                hjust = 1.2
            )) +
        ggplot2::labs(x = "Taxa de ocorrências por 100 mil habitantes", y = "", 
                      subtitle = subtitulo,
                      caption = "**Dataviz:** @maykongpedro | **Fonte:** SSP (Dados organizados pela Curso-R)") +
        ggplot2::ggtitle(titulo) +
        ggplot2::theme_minimal() +
        ggplot2::theme(plot.title = ggplot2::element_text(face = "bold", hjust = 0.5),
                       plot.subtitle = ggplot2::element_text(hjust = 0.5),
                       axis.line.y = ggplot2::element_line(size = 1),
                       axis.text.x = ggplot2::element_blank(),
                       plot.caption = ggtext::element_markdown(hjust = 1),
                       plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm"))
    
}
