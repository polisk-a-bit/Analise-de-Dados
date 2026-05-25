import requests
import json

url = "https://apisidra.ibge.gov.br/values/t/5938/n3/all/v/37/p/last/f/c"

request=requests.get(url)   #Faz a requisição dos dados
PIB_estados=request.json()    #Transforma os dados em uma lista json

with open('PIB_estados.json', 'w', encoding='utf-8') as arquivo:     #Cria um arquivo .json para escrita ('w')
    json.dump(PIB_estados, arquivo, ensure_ascii=False, indent=6)     #Envia os dados para o arquivo 
    #ensure_ascii = False <- garante que a acentuação seja mantida
    #indent = 6 <- identa os dados