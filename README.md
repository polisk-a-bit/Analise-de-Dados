# Analise-de-Dados
Projeto de análise de dados utilizando Python, SQL e PowerBI

--Sumário dos Arquivos:

  - `Fase 1 Python` - Aqui estão localizados os bancos de dados que foram utilizados no projeto, assim como os arquivos Python utilizados para o processo de ETL.
    - `1.Banco de dados base` - Pasta onde o arquivo base original está armazenado.
    - `2.Códigos python` - Pasta onde os arquivos Python estão armazenados.
      - `1.corretor_bd.py` - Algoritmo feito para identificar e corrigir possíveis erros de digitação no BD.
      - `2.PIB_estados.py` - Algoritmo feito para baixar o banco de dados do IBGE do PIB dos estados brasileiros, e transformá-lo em um arquivo .json.
      - `3.populacao_estados.py` - Algoritmo feito para baixar o banco de dados do IBGE da população dos estados brasileiros, e transformá-lo em um DataFrame da biblioteca pandas.
      - `4.merge_BD.py` - Realiza um merge entre o dado original (agora limpo) e o banco de dados do PIB.
    - `3.BDs` - Aqui se encontram os BDs obtidos pelo `1.corretor_bd.py` e `2.PIB_estados.py`.
    - `4.BDs finais` - Aqui se encontram os BDs obtidos pelo `3.populacao_estados.py` e `4.merge_BD.py` que serão utilizados nas próximas fases do projeto.

  - `Fase 2 SQL` - Pasta onde está localizado o arquivo SQL utilizado na criação das View do projeto.
    - `PesquisasSQL.sql` - As buscas SQL neste arquivo geraram diferentes Views, tais como: Dados A3 (principal View do projeto, com informações da estimativa de lucro de cada estado e Market Share),
         Dados Estados (calcula a presença do estado no mercado e o PIB per capta), Dados Clientes (calcula a população total de cada estado, o número total de clientes, o número de clientes recorrentes e
         a densidade clientes por habitante), Desertos de Entrega (calula quais cidades brasileiras tem a cobertura mais baixa).

  - `Fase 3 Power BI` - Pasta onde está localizado o Dashboard do projeto.
    - `Dashboard.pbix` - Dashboard com insights sobre a análise do mercado com mapa interativo.   
