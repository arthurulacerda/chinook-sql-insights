/* Gráfico 1 */
/* Query utilizada para descobrir qual é o gênero musical mais vendido em cada país. */
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
