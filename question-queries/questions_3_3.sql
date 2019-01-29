--Pergunta 3
--Escreva uma consulta que determina qual cliente gastou mais em músicas por país. Escreva uma consulta que retorna o país junto ao principal cliente e quanto ele gastou. Para países que compartilham a quantia total gasta, forneça todos os clientes que gastaram essa quantia.

--Você só precisará usar as tabelas Customer (cliente) e Invoice (fatura).

SELECT T1.*
FROM (
  SELECT c.Country,
         SUM(i.Total) AS TotalSpent,
         c.FirstName,
         c.LastName,
         c.CustomerId
  FROM Customer AS c
  JOIN Invoice  AS i ON i.CustomerId = c.CustomerId
  GROUP BY 1,3,4,5
) AS T1
JOIN (
  SELECT MAX(TotalSpent) MaxSpent,
         Country
  FROM (
    SELECT SUM(i.Total) AS TotalSpent,
           c.CustomerId,
           c.Country
    FROM Customer AS c
    JOIN Invoice  AS i ON i.CustomerId = c.CustomerId
    GROUP BY 2
  ) AS T2
  GROUP BY 2
) AS T3
ON T1.Country = T3.Country AND T1.TotalSpent = T3.MaxSpent
ORDER BY T1.Country;


