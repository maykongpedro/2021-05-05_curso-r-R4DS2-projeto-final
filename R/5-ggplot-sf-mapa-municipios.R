#' mapa_municipios
#'
#' Descrição da função
#' 
#' @param db_shape base de dados com os valores e geometria do que será preenchido
#' @param shape_geral mapa base, vai ficar de fundo
#' @param valores valores que serão usados como preenchimento do mapa
#' @param titulo título do mapa
#' @param subtitulo subtítulo do mapa
#' 
#' @return retorna um gráfico de linhas dentro do estilo proposto para a análise
#' 
mapa_municipios <- function(db_shape, 
                            shape_geral,
                            valores,
                            titulo, 
                            subtitulo,
                            rotulos) {
        ggplot2::ggplot() +
        ggplot2::geom_sf(data = shape_geral,
                         alpha = .9,
                         color = "white",
                         size = 0.5) +
        ggplot2::geom_sf(data = db_shape, ggplot2::aes(fill = {{valores}}),
                         color = "#5A5A5A",
                         size = .5) +
        ggplot2::scale_fill_viridis_d(direction = -1)+
        ggplot2::labs(fill = "Taxa de ocorrências \n(por 100mil hab.)",
                      subtitle = subtitulo,
                      caption = "**Dataviz:** @maykongpedro | **Fonte:** SSP (Dados organizados pela Curso-R)") +
        ggplot2::ggtitle(titulo) +
        ggspatial::annotation_north_arrow(
            location = "br",
            which_north = "true",
            height = ggplot2::unit(1, "cm"),
            width = ggplot2::unit(1, "cm"),
            pad_x = ggplot2::unit(0.1, "in"),
            pad_y = ggplot2::unit(0.1, "in"),
            style = ggspatial::north_arrow_fancy_orienteering
        ) +
        ggspatial::annotation_scale() +
        ggplot2::theme_bw() +
        ggplot2::theme(plot.title = ggplot2::element_text(face = "bold", hjust = 0.5),
                       plot.subtitle = ggtext::element_markdown(hjust = 0.5),
                       plot.caption = ggtext::element_markdown(hjust = 1))
}
