import pandas as pd

dados_tabela = pd.read_csv('BDs/dados_atualizados.csv')
PIB = pd.read_json('BDs/PIB_estados.json')

dados = pd.merge(dados_tabela, PIB, left_on='customer_state', right_on='D4C', how='outer') # Junta os dados dos dois BDs em um único

dados.to_csv('BD_A3.csv')