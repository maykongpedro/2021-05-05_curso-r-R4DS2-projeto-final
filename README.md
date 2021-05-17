
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Análise do histórico de 2002 a 2020 de ocorrências de crimes da **Secretaria da Segurança Pública de São Paulo (SSP-SP)**

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
Paulo**, uma base adivinda da própria secretaria, porém tratada e
organizada pela equipe da Curso R, onde temos o compilado de ocorrências
criminais por delegacia, município, ano e mês.

Além dessa base foi utilizado uma planilha com os dados de população
estimada para cada município do estado de SP, além do shape dos
municípios.

As bases são detalhadas abaixo:

### SSP

-   Descrição: número de ocorrências mensais de diversos crimes de 2002
    a 2020 este último apenas até abril) no nível delegacia para todo o
    Estado de São Paulo.
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

|             Crime/Ocorrência             |   Categoria    |
|:----------------------------------------:|:--------------:|
|              estupro\_total              |    estupro     |
|              furto\_outros               |     furto      |
|             furto\_veiculos              |     furto      |
|     hom\_culposo\_acidente\_transito     |   homicidio    |
|           hom\_culposo\_outros           |   homicidio    |
|               hom\_doloso                |   homicidio    |
|     hom\_doloso\_acidente\_transito      |   homicidio    |
|              hom\_tentativa              |   homicidio    |
|                latrocinio                |   latrocinio   |
| lesao\_corp\_culposa\_acidente\_transito | lesão corporal |
|       lesao\_corp\_culposa\_outras       | lesão corporal |
|           lesao\_corp\_dolosa            | lesão corporal |
|         lesao\_corp\_seg\_morte          | lesão corporal |
|               roubo\_total               |     roubo      |

Fonte: SSP (Dados organizados pela Curso-R)

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

Para as análises a seguir o ano de 2020 foi desconsiderado, por possuir
apenas dados para apenas os quatro primeiros meses. Esse ano em
específico foi destacado na avaliação de ocorrências durante o início da
pandemia de Covid-19.

### Histórico por categoria de crime

No gráfico abaixo podemos perceber como a soma total de ocorrências
estão diminuindo ao longo do tempo, sendo o ano de 2018 e 2019 os mais
baixos dentro do histórico. Os destaques estão no triênio de 2012 a
2014, onde o número total de ocorrências se manteve aproximadamente em
1257milhão, após isso apresentou queda.

Também pode-se extrair os tipos de crimes mais comuns dentro da base,
sendo o furto o mais proeminente, seguido de lesão corporal e roubo.

![](https://github.com/maykongpedro/2021-05-05_curso-r-R4DS2-projeto-final/blob/master/inst/hist_ocorrencias_ate_2019.png)

Se consideramos as categorias de crimes que possuem mais de **50mil**
ocorrências, temos o seguinte comportamento no histórico:

![](https://github.com/maykongpedro/2021-05-05_curso-r-R4DS2-projeto-final/blob/master/inst/hist_ocorrencias_mais_expressivas.png)
Onde podemos observar que no geral as três categorias mantém um certo
padrão ao longo dos anos, apenas mudando a partir de 2014, onde a
categoria de **lesão corporal** começou a diminuir e a de **roubo** a
subir, no mesmo ano.

### Mês mais violento dentro do histórico

Um questionamnto interessante é verificar se existe algum período do ano
onde a ocorrência de crimes é maior, sendo os motivos impossíveis de
justificar somente com o escopo desse trabalho.

Um jeito simples de verificar é somando as ocorrências de todos os meses
dentro da base, identificando qual mês que mais possui ocorrências, o
resultado pode ser observado no gráfico abaixo:

![](https://github.com/maykongpedro/2021-05-05_curso-r-R4DS2-projeto-final/blob/master/inst/mes_mais_violento.png)

### Geral - Cidades com maiores taxas de ocorrência por 100mib hab.

|       Município       | Tx de ocorrência por 100 mil hab. (Mil) | Média histórica da População(Mil) |
|:---------------------:|:---------------------------------------:|:---------------------------------:|
|       São Paulo       |                7321.531                 |            11404.5855             |
|       Campinas        |                 706.633                 |             1100.2687             |
|       Guarulhos       |                 473.274                 |             1276.0717             |
|    Ribeirão Preto     |                 397.629                 |             607.9818              |
|      Santo André      |                 389.398                 |             686.7706              |
| São Bernardo do Campo |                 369.643                 |             795.7672              |
|        Osasco         |                 315.288                 |             693.6636              |
|       Sorocaba        |                 295.831                 |             601.7070              |
|        Santos         |                 289.602                 |             424.4917              |
|  São José dos Campos  |                 270.342                 |             641.4852              |
| São José do Rio Preto |                 268.228                 |             421.6735              |
|         Bauru         |                 219.286                 |             355.9506              |
|      Piracicaba       |                 214.608                 |             373.9052              |
|     Praia Grande      |                 211.114                 |             267.3108              |
|        Diadema        |                 197.537                 |             398.2279              |
|        Jundiaí        |                 195.316                 |             372.6142              |
|        Franca         |                 190.466                 |             329.5417              |
|      São Vicente      |                 175.179                 |             338.8696              |
|         Mauá          |                 154.508                 |             427.4037              |
|        Taubaté        |                 153.032                 |             283.6991              |

Fonte: SSP (Dados organizados pela Curso-R) & IBGE

![](https://github.com/maykongpedro/2021-05-05_curso-r-R4DS2-projeto-final/blob/master/inst/mapa_geral.png)

## Avaliação de criminalidade durante a quarentena

### Histórico geral - Primeiro Quadrimestre

![](https://github.com/maykongpedro/2021-05-05_curso-r-R4DS2-projeto-final/blob/master/inst/hist_quadrimestre_covid.png)

### Comparativo do último ano

![](https://github.com/maykongpedro/2021-05-05_curso-r-R4DS2-projeto-final/blob/master/inst/hist_ano_covid.png)

`devtools::build_readme()` i
