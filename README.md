
<!-- README.md is generated from README.Rmd. Please edit that file -->

# 2021-05-05\_curso-r-R4DS2-projeto-final

<!-- badges: start -->
<!-- badges: end -->

# Introdução

## Motivação

Esse repositório tem como motivação servir de entrega para o trabalho
final de conclusão de curso do [Curso R para Ciência de Dados 2 da Curso
R](https://curso-r.com/cursos/r4ds-2/).

## Objetivo

Analisar umas das bases disponibilizadas pelos professores ou uma base
própria, utilizando o conhecimento adquirido no curso.

## Base de dados

A base escolhida foi a da **Secretaria de Segurança Pública (SSP) de São
Paulo**, uma base tratada pela equipe da Curso R, onde temos o compilado
de ocorrências criminais por delegacia, município, ano e mês.

Além dessa base foi utilizado uma planilha com os dados de população
estimada para cada município do estado de SP, além do shape dos
municípios.

As bases são detalhadas abaixo:

### SSP

-   Descrição: número de ocorrências mensais de diversos crimes de 2002
    a 2020 (abril) no nível delegacia para todo o Estado de São Paulo.
-   Variáveis:
-   Fonte: SSP-SP - Dados compilados e organizados pela Curso R.

### População por município

-   Descrição: população estimada para cada município do estado de São
    Paulo.
-   Variáveis: codigo\_ibge, municipio\_nome, colunas respectivas para
    cada ano (2002 a 2020)
-   Fonte: IBGE

### Shape dos municípios

-   Descrição: *simple feature* dos municípios do estado de São Paulo.
-   Variáveis: codigo\_ibge, municipio\_nome, colunas respectivas para
    cada ano (2002 a 2020)
-   Fonte: IBGE / geobr / RDS gerado pela curso R.

# Análises

Como recomendação para a atividade, os seguintes pontos foram analisados
durante esse trabalho:

-   Séries de criminalidade
-   Avaliação sobre os níveis de criminalidade durante a quarentena -
    existe alguma diferença com o restante do histórico?
-   Distribuição espacial das ocorrências de criminalidade.

Para facilitar a análise, os crimes contidos dentro da base foram
classificados pela própria nomenclatura, gerando 6 categorias de crime
que resumem os dados. Essas categorias não tem como pretensão serem
corretas se vistas por aspectos do Direito Penal, são apenas
simplificações dentro do escopo desse trabalho. A classificação de
categoria pode ser verificada na tabela a seguir:

<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#neetgaxrnz .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#neetgaxrnz .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#neetgaxrnz .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#neetgaxrnz .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#neetgaxrnz .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#neetgaxrnz .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#neetgaxrnz .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#neetgaxrnz .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#neetgaxrnz .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#neetgaxrnz .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#neetgaxrnz .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#neetgaxrnz .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#neetgaxrnz .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#neetgaxrnz .gt_from_md > :first-child {
  margin-top: 0;
}

#neetgaxrnz .gt_from_md > :last-child {
  margin-bottom: 0;
}

#neetgaxrnz .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#neetgaxrnz .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#neetgaxrnz .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#neetgaxrnz .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#neetgaxrnz .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#neetgaxrnz .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#neetgaxrnz .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#neetgaxrnz .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#neetgaxrnz .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#neetgaxrnz .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#neetgaxrnz .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#neetgaxrnz .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#neetgaxrnz .gt_left {
  text-align: left;
}

#neetgaxrnz .gt_center {
  text-align: center;
}

#neetgaxrnz .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#neetgaxrnz .gt_font_normal {
  font-weight: normal;
}

#neetgaxrnz .gt_font_bold {
  font-weight: bold;
}

#neetgaxrnz .gt_font_italic {
  font-style: italic;
}

#neetgaxrnz .gt_super {
  font-size: 65%;
}

#neetgaxrnz .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="neetgaxrnz" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;"><table class="gt_table">
  <thead class="gt_header">
    <tr>
      <th colspan="2" class="gt_heading gt_title gt_font_normal" style>Crimes e categorias por ocorrência</th>
    </tr>
    <tr>
      <th colspan="2" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>Classificação realizada para a análise</th>
    </tr>
  </thead>
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Crime/Ocorrência</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Categoria teórica</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr>
      <td class="gt_row gt_left">estupro_total</td>
      <td class="gt_row gt_left">estupro</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">furto_outros</td>
      <td class="gt_row gt_left">furto</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">furto_veiculos</td>
      <td class="gt_row gt_left">furto</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">hom_culposo_acidente_transito</td>
      <td class="gt_row gt_left">homicidio</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">hom_culposo_outros</td>
      <td class="gt_row gt_left">homicidio</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">hom_doloso</td>
      <td class="gt_row gt_left">homicidio</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">hom_doloso_acidente_transito</td>
      <td class="gt_row gt_left">homicidio</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">hom_tentativa</td>
      <td class="gt_row gt_left">homicidio</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">latrocinio</td>
      <td class="gt_row gt_left">latrocinio</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">lesao_corp_culposa_acidente_transito</td>
      <td class="gt_row gt_left">lesão corporal</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">lesao_corp_culposa_outras</td>
      <td class="gt_row gt_left">lesão corporal</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">lesao_corp_dolosa</td>
      <td class="gt_row gt_left">lesão corporal</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">lesao_corp_seg_morte</td>
      <td class="gt_row gt_left">lesão corporal</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">roubo_total</td>
      <td class="gt_row gt_left">roubo</td>
    </tr>
  </tbody>
  <tfoot class="gt_sourcenotes">
    <tr>
      <td class="gt_sourcenote" colspan="2">Fonte: SSP (Dados organizados pela Curso-R)</td>
    </tr>
  </tfoot>
  
</table></div>

Além disso, foi necessário realizar outros dois procedimentos como
premissas, sendo esses:

-   Dentro da base SSP constam colunas onde são informadas as vítimas de
    alguns crimes, essas foram excluídas da análise como um todo.

-   Crimes de estupro e roubo possuem sub-categorias e estas são somadas
    em uma coluna de “total”, contudo, na categoria de estupro se somo
    as sub-categorias, não chego no resultado do total, indicando um
    possível erro na base. Para evitar sub-estimativa, ignorei essas
    categorais e considerei apenas o “total”.

## Séries de criminalidade

### Histórico por categoria de crime

![](https://github.com/maykongpedro/2021-05-05_curso-r-R4DS2-projeto-final/blob/master/inst/hist_ocorrencias_ate_2019.png)

### Mês mais violento dentro do histórico

![](https://github.com/maykongpedro/2021-05-05_curso-r-R4DS2-projeto-final/blob/master/inst/mes_mais_violento.png)

### Geral - Cidades com maiores taxas de ocorrência por 100mib hab.

![](https://github.com/maykongpedro/2021-05-05_curso-r-R4DS2-projeto-final/blob/master/inst/mapa_geral.png)

## Avaliação de criminalidade durante a quarentena

### Histórico geral - Primeiro Quadrimestre

![](https://github.com/maykongpedro/2021-05-05_curso-r-R4DS2-projeto-final/blob/master/inst/hist_quadrimestre_covid.png)

### Comparativo do último ano

![](https://github.com/maykongpedro/2021-05-05_curso-r-R4DS2-projeto-final/blob/master/inst/hist_ano_covid.png)

`devtools::build_readme()` i
