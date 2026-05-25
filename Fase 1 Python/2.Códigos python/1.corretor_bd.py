import pandas as pd
from rapidfuzz import process, fuzz

df = pd.read_csv('g2g4.csv')

def encontrar_typos(cidades, taxa_semelhanca = 85, similares = 5):
    valores_comuns = cidades.value_counts().head(100).index.tolist() # Conta os 100 valores mais comuns e transforma em uma lista

    suspeitos = []

    for valor_estranho in cidades.value_counts().tail(500).index: # Cria um loop para cada valor exótico da coluna
        if pd.isna(valor_estranho): # Verifica se o valor é nulo e, caso seja, o ignora
            continue

        valores = process.extract(valor_estranho, valores_comuns, scorer=fuzz.ratio, limit=similares) # Compara valor_estranho com valores_comuns
        # scorer=fuzz.ratio calcula a porcentagem de similaridade entre os dois
        # limit=similares retorna as 5 sugestões de correção

        for sugestao, porcentagem, _ in valores: # Seleciona a sugestão e a porcentagem de similaridade em valores
            if porcentagem >= taxa_semelhanca and sugestao != valor_estranho: # Caso porcentagem seja maior do que a taxa de semelhança e a sugestão for diferente de valor ('é parecido mas não é igual')
                suspeitos.append({
                    'Valor_errado': valor_estranho,
                    'Sugestao': sugestao,
                    'Taxa_similaridade': porcentagem,
                    'Frequencia': cidades.value_counts()[valor_estranho]
                }) # Adiciona o suspeito à lista
    
    return pd.DataFrame(suspeitos).sort_values('Taxa_similaridade', ascending=False) # Retorna um DataFrame dos valores suspeitos de acordo com a taxa de similaridade decrescente


def alterar_valores(df, df_erros):
    
    correcoes = df_erros.groupby('Valor_errado').first()[['Sugestao']].to_dict()['Sugestao'] # Seleciona somente a primeira sugestão da coluna de sugestões
    # e agrupa por Valor_errado. Depois transforma em um dicionário

    df['customer_city'] = df['customer_city'].replace(correcoes) # Substitui o nome errado pela sugestão de correção
    
    return df

erros = encontrar_typos(df['customer_city'], taxa_semelhanca=80) # Envia a coluna com o mínimo de similaridade que uma palavra deve ter para ser um typo
print(f"{'=' * 90}\n{erros}\n")

df = alterar_valores(df, erros)

print(f"{'=' * 90}\n{df.head(20)}\n")

df.to_csv('BDs/dados_atualizados.csv') # Salva uma cópia corrigida 

