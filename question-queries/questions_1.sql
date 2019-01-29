--Pergunta 1: Quais países possuem mais faturas?
--Use a tabela Invoice (Fatura) para determinar quais países possuem mais faturas. Forneça as tabelas de BillingCountry (país de cobrança) e Invoices (faturas) ordenadas pelo número de faturas para cada país. O país com mais faturas deve aparecer primeiro.

SELECT BillingCountry,
       COUNT(*) AS Invoices
  FROM Invoice
  GROUP BY 1
  ORDER BY 2 DESC;


--Pergunta 2: Qual cidade tem os melhores clientes?
--Gostaríamos de lançar um festival de música promocional na cidade que nos gerou mais dinheiro. Escreva uma consulta que retorna a cidade que possui a maior soma dos totais de fatura. Retorne tanto o nome da cidade quanto a soma de todos os totais de fatura.

SELECT BillingCity,
       SUM(Total) AS SumTotal
  FROM Invoice
  GROUP BY 1
  ORDER BY 2 DESC;

--Pergunta 3: Quem é o melhor cliente?
--O cliente que gastou mais dinheiro será declarado o melhor cliente. Crie uma consulta que retorna a pessoa que mais gastou dinheiro. Eu encontrei a solução linkando as três seguintes tabelas: Invoice (fatura), InvoiceLine (linha de faturamento) e Customer (cliente), para recuperar essa informação, mas você probabelmente consegue fazê-lo com menos!

SELECT c.FirstName AS CustomermerFirstName,
       c.CustomerId As CustomerId,
       SUM(i.Total) AS TotalSpent
  FROM Invoice AS i
  JOIN Customer AS c ON c.CustomerId = i.CustomerId
  GROUP BY 1,2
  ORDER BY 3 DESC;
