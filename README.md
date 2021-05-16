
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
