import requests
import json
import pandas as pd

url = 'https://apisidra.ibge.gov.br/values/T/6579/N3/all/V/9324/P/last'

request = requests.get(url)
populacao = request.json()

bd = pd.DataFrame(populacao) # Transforma o conteúdo json em um DataFrame do pandas

bd.to_csv('populacao_estados.csv')