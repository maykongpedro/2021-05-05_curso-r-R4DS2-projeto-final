
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
    a 2020 (esse último apenas até abril) no nível delegacia para todo o
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
-   Distribuição espacial das ocorrências de criminalidade.
-   Avaliação sobre os níveis de criminalidade durante a quarentena -
    existe alguma diferença com o restante do histórico?

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
apenas dados para os quatro primeiros meses. Esse ano em específico foi
destacado na avaliação de ocorrências durante o início da pandemia de
Covid-19.

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

Um questionamento interessante é verificar se existe algum período do
ano onde a ocorrência de crimes é maior, sendo os motivos impossíveis de
justificar somente com o escopo desse trabalho.

Um jeito simples de verificar é somando as ocorrências de todos os meses
dentro da base, identificando qual mês que mais possui ocorrências, o
resultado pode ser observado no gráfico abaixo:

![](https://github.com/maykongpedro/2021-05-05_curso-r-R4DS2-projeto-final/blob/master/inst/mes_mais_violento.png)

### Geral - Cidades com maiores taxas de ocorrência de crimes

Para esse item será usada a taxa de ocorrência de crime para cada 100
mil habitantes¹, por se tratar de análise comparativa entre municípios,
sendo lógico “normalizar” as ocorrências para a quantidade populacional
de cada cidade.

Filtrando somente os municípios com no mínimo 100 mil habitantes, e
aplicando o cálculo da taxa, chegamos em uma lista dos 20 municípios do
estado de São Paulo com maiores taxas de ocorrências de crime dentro do
histórico estudado.

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

A cidade de São Paulo lidera o ranking, sendo algo natural por ser a
cidade mais populosa da América Latina, com uma soma de 7322 milhão de
taxa de ocorrência de crimes por 100mil hab.

Um resultado surpreendente é que não necessariamente os municípios no
ranking seguem a grandeza da média populacional do histórico. A segunda
cidade com maior tx. é Campinas, possuindo uma média de 1100 milhão de
habitantes, 176 mil a menos que a terceira cidade, Guarulhos. Implicando
nesse caso em uma incidência de crimes realmente maior, e não derivada
diretamente da quantidade de habitantes. Essa mesma situação pode ser
verificada com outros municípios.

Na mapa² baixo podemos verificar a distribuição espacial das taxas de
ocorrência por 100mil hab. de todas as cidades com o mínimo de
habitantes necessário para a correta utilização desse cálculo, sendo a
cor um indicadivo da intensidade da classe de ocorrências³.

![](https://github.com/maykongpedro/2021-05-05_curso-r-R4DS2-projeto-final/blob/master/inst/mapa_geral.png)

## Avaliação de criminalidade durante a quarentena

Como comentado anteriormente, uma recomendação de análise levantada
pelos instrutores da Curso R é identificar se houve alguma diferença no
número de ocorrências durante a quarentena de Covid-19, que se iniciou
em Março do 2020.

### Histórico geral - Primeiro Quadrimestre

No gráfico abaixo podemos verificar o histórico anual da base
considerando apenas os meses de Janeiro até Abril, por ser o último mês
com dados no ano de 2020. A linha de corte destaca o quão baixo ficou o
número de ocorrências se comparado com o mesmo período dos anos
anteriores, demonstrando claramente a diminuição das ocorrências em
2020, isso podendo ser pelo próprio fechamento de delegacias durante a
quarentena (ou seja, diminuindo um pouco o lançamento dos dados), ou
pela própria restrição de circulação no estado, impedindo o aumento nas
ocorrências de crimes.

![](https://github.com/maykongpedro/2021-05-05_curso-r-R4DS2-projeto-final/blob/master/inst/hist_quadrimestre_covid.png)

### Comparativo do último ano

Esse item tem como objetivo mostrar o comportamento do número de
ocorrências de crimes no estado de São Paulo de Abril/2019 até
Abril/2020, onde podemos ver uma diminuição de -46% deste último com o
ano de 2019.

![](https://github.com/maykongpedro/2021-05-05_curso-r-R4DS2-projeto-final/blob/master/inst/covid_mes.png)

# Conclusões

Com essa análise, foi possível retirar algumas respostas a partir dos
dados, como:

-   comportamento do histórico de ocorrências de crimes
-   quais as categorias de crimes mais comuns no estado
-   possível sazonalidade de ocorrências no ano
-   ranking dos municípios com maiores taxas de crime por 100mil
    habitantes
-   distribuição espacial desses municípios
-   comprovação de diferença real do ano de 2020 (início da pandemia de
    Covid-19) para com o restante do histórico

Com isso, podemos ver a importância da disponibização de dados públicos,
permitindo aos mais diversos usuários e setores o estudo desses dados,
gerando diferentes resultados e conclusões que podem ser usadas para
possíveis melhorias de políticas públicas por parte do Governo.

# Comentários pessoais

Esse trabalho exigiu um esforço de pesquisa e revisão do material dado
em aula, permitindo a utilização dos conhecimentos apresentados ao longo
do curso.

Foi um aprendizado gigantesco montar e organizar essa análise. Apesar de
entregue 1 semana após o prazo estabelecido (devido a problemas
pessoais), o esforço dispedindo foi gratificante. Sou grato aos
instrutores da Curso R por nos apresentarem de forma didática e incrível
as capacidades da linguagem R.

# Notas

1.  Mais informações sobre essa prática podem ser obtidas no seguite
    link: [Taxa por 100mil
    habitantes](http://www.ssp.sp.gov.br/fale/estatisticas/answers.aspx?t=6)

2.  O mapa foi construído usando de base o excelente
    [tutorial/post](https://beatrizmilz.com/posts/2020-07-27-criando-mapas-com-os-pacotes-tidyverse-e-geobr/)
    da Beatriz Milz em seu blog pessoal.

3.  A classificação e repartição dos números facilita a compreensão da
    escala de cores, uma dica que obtive no
    [post](https://blog.curso-r.com/posts/2019-02-10-sf-miojo/) do Julio
    Trecentini, no blog da Curso R.
