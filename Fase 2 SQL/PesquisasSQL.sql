SELECT * FROM Clientes;
SELECT * FROM populacao_estados;


CREATE VIEW[Dados Estados] AS
SELECT 
	c.Unidade_da_Federação_Sigla, 
	((c.PIB * 1000) /p.População) AS 'PIB_per_capta', /* Calcula o PIB per capta. Multiplica por 1.000 porque o PIB está com uma unidade de medida diferente */
	COUNT(Unidade_da_Federação_Sigla) * 100.0 
		/ (SELECT COUNT(*) FROM Clientes) AS '% da Presença no Mercado' /* Calcula a % da presença do estado no mercado */
FROM Clientes c
JOIN populacao_estados p 
	ON c.Unidade_da_Federação_Código = p.Unidade_da_Federação_Código
GROUP BY 
	c.Unidade_da_Federação_Sigla, 
	c.PIB, 
	p.População;


CREATE VIEW[Dados A3] AS
SELECT t.Unidade_da_Federação_Sigla, 
t.Estimativa_Faturamento_Regional,
CAST(t.Estimativa_Faturamento_Regional AS FLOAT) / SUM(t.Estimativa_Faturamento_Regional) OVER() * 100 AS '% Market Share'
FROM (SELECT 
	    c.Unidade_da_Federação_Sigla, 
	    COUNT(DISTINCT c.customer_unique_id) * d.PIB_per_capta AS Estimativa_Faturamento_Regional /* Calcula a estimativa do lucro por região */
    FROM Clientes c
    JOIN [Dados Estados] d 
	    ON c.Unidade_da_Federação_Sigla = d.Unidade_da_Federação_Sigla
    GROUP BY 
	    c.Unidade_da_Federação_Sigla,
	    d.PIB_per_capta
        ) t
GROUP BY t.Unidade_da_Federação_Sigla, t.Estimativa_Faturamento_Regional
ORDER BY t.Unidade_da_Federação_Sigla ASC


CREATE VIEW[Dados Clientes] AS
SELECT c.Unidade_da_Federação_Sigla,
COUNT(DISTINCT c.customer_unique_id) AS 'Total Clientes',
COUNT(CASE WHEN t.qtd > 1 THEN 1 END) AS 'Clientes Recorrentes',
p.População AS 'Habitantes',
CAST(COUNT(DISTINCT c.customer_unique_id) AS FLOAT) / p.População * 100 AS '% Densidade Clientes/Habitante'
FROM Clientes c
JOIN populacao_estados p 
ON p.Unidade_da_Federação_Código = c.Unidade_da_Federação_Código
JOIN (SELECT customer_unique_id, COUNT(customer_unique_id) AS qtd FROM Clientes GROUP BY customer_unique_id) t 
ON t.customer_unique_id = c.customer_unique_id
GROUP BY c.Unidade_da_Federação_Sigla, p.População


CREATE VIEW[Desertos de Entrega] AS
SELECT t.Cidade, t.UF,
t.Cep_prefixo,
t.Clientes,
SUM(t.Clientes) OVER (PARTITION BY t.Cidade) AS Total_Cidade,
CAST(t.Clientes AS FLOAT) / SUM(t.Clientes) OVER (PARTITION BY t.Cidade) 
    AS Participacao_CEP_na_Cidade,
CASE 
    WHEN CAST(t.Clientes AS FLOAT) 
        / SUM(t.Clientes) OVER (PARTITION BY t.Cidade) < 0.01 
    THEN 'Deserto Potencial'
    WHEN CAST(t.Clientes AS FLOAT) 
        / SUM(t.Clientes) OVER (PARTITION BY t.Cidade) < 0.05 
    THEN 'Baixa Cobertura'
        ELSE 'Normal'
    END AS Status
FROM (
    SELECT customer_city AS Cidade, Unidade_da_Federação_Sigla AS UF , 
        LEFT(customer_zip_code_prefix, 5) AS Cep_prefixo,
        COUNT(DISTINCT customer_unique_id) AS Clientes
    FROM Clientes
    GROUP BY 
        customer_city,
        Unidade_da_Federação_Sigla,
        LEFT(customer_zip_code_prefix, 5)
) t


CREATE VIEW[Dados Cidades] AS
SELECT customer_city AS Cidades, Unidade_da_Federação_Sigla AS UF, COUNT(customer_unique_id) AS Clientes
FROM Clientes
GROUP BY customer_city, Unidade_da_Federação_Sigla


SELECT * FROM [Dados A3];
SELECT * FROM [Dados Estados];
--JOIN [Dados A3] ON [Dados Estados].Unidade_da_Federação_Sigla = [Dados A3].Unidade_da_Federação_Sigla
SELECT * FROM [Dados Clientes];
SELECT * FROM [Desertos de Entrega];
SELECT * FROM [Dados Cidades];


SELECT TOP 10 Unidade_da_Federação_Sigla, [% Densidade Clientes/Habitante] FROM [Dados Clientes] ORDER BY [% Densidade Clientes/Habitante] DESC;

SELECT TOP 10 UF,COUNT(UF) AS CTG , Cidade,Status FROM [Desertos de Entrega] WHERE Status = 'Baixa Cobertura' GROUP BY UF, Status, Cidade ORDER BY CTG desc ;
