--Pergunta 1
--Queremos descobrir o gênero musical mais popular em cada país. Determinamos o gênero mais popular como o gênero com o maior número de compras. Escreva uma consulta que retorna cada país juntamente a seu gênero mais vendido. Para países onde o número máximo de compras é compartilhado retorne todos os gêneros.

--Para essa consulta você precisará usar as tabelas Invoice (fatura), InvoiceLine (linha de faturamento), Track (música), Customer (cliente) e Genre (gênero).

WITH
TrackSalesByCountry AS (
  SELECT g.GenreId AS GenreId,
         g.Name AS GenreName,
         c.Country AS Country,
         SUM(il.Quantity) AS TrackSalesQuantity
  FROM Genre AS g
  INNER JOIN Track       AS t  ON t.GenreId = g.GenreId
  INNER JOIN InvoiceLine AS il ON il.TrackId = t.TrackId
  INNER JOIN Invoice     AS i  ON i.InvoiceId = il.InvoiceId
  INNER JOIN Customer    AS c  ON c.CustomerId = i.CustomerId
  GROUP BY 1,2,3
),
MaxSalesByCountry AS (
  SELECT Country,
         MAX(TrackSalesQuantity) AS MaxTrackSalesQuantity
  FROM TrackSalesByCountry
  GROUP BY 1
)

SELECT tsbc.Country,
       tsbc.TrackSalesQuantity,
       tsbc.GenreId,
       tsbc.GenreName
FROM MaxSalesByCountry AS msbc
JOIN TrackSalesByCountry AS tsbc ON
  tsbc.TrackSalesQuantity = msbc.MaxTrackSalesQuantity
  AND tsbc.Country = msbc.Country
ORDER BY 2 DESC, 1;


