/* Gráfico 4 */
/* Utilizei a seguinte query do WITH para obter os top 3 gêneros que possuem maior quantidade de vendas,
 para então na query seguinte obter a quantidade de vendas por ano destes gêneros*/
WITH Top1Genre AS (
  SELECT Genre.GenreId,
         Genre.Name,
         COUNT(InvoiceLine.Quantity) AS QuantitySold
  FROM Genre
  INNER JOIN Track       ON Track.GenreId = Genre.GenreId
  INNER JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
  GROUP BY 1,2
  ORDER BY 3 DESC
  LIMIT 1
), Top2Genre AS (
  SELECT Genre.GenreId,
         Genre.Name,
         COUNT(InvoiceLine.Quantity) AS QuantitySold
  FROM Genre
  INNER JOIN Track       ON Track.GenreId = Genre.GenreId
  INNER JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
  GROUP BY 1,2
  ORDER BY 3 DESC
  LIMIT 1 OFFSET 1
), Top3Genre AS (
  SELECT Genre.GenreId,
         Genre.Name,
         COUNT(InvoiceLine.Quantity) AS QuantitySold
  FROM Genre
  INNER JOIN Track       ON Track.GenreId = Genre.GenreId
  INNER JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
  GROUP BY 1,2
  ORDER BY 3 DESC
  LIMIT 1 OFFSET 2
), Top1ByYear AS (
SELECT datetime(InvoiceDate, 'start of year') AS Year,
       Genre.Name,
       Genre.GenreId,
       SUM(InvoiceLine.Quantity) AS QuantitySold
FROM Invoice
JOIN InvoiceLine ON InvoiceLine.InvoiceId = Invoice.InvoiceId
JOIN Track       ON Track.TrackId = InvoiceLine.TrackId
JOIN Genre       ON Genre.GenreId = Track.GenreId
WHERE Genre.GenreId = (SELECT GenreId FROM Top1Genre)
GROUP BY 1
ORDER BY 1
), Top2ByYear AS (
SELECT datetime(InvoiceDate, 'start of year') AS Year,
       Genre.Name,
       Genre.GenreId,
       SUM(InvoiceLine.Quantity) AS QuantitySold
FROM Invoice
JOIN InvoiceLine ON InvoiceLine.InvoiceId = Invoice.InvoiceId
JOIN Track       ON Track.TrackId = InvoiceLine.TrackId
JOIN Genre       ON Genre.GenreId = Track.GenreId
WHERE Genre.GenreId = (SELECT GenreId FROM Top2Genre)
GROUP BY 1
ORDER BY 1
), Top3ByYear AS (
SELECT datetime(InvoiceDate, 'start of year') AS Year,
       Genre.Name,
       Genre.GenreId,
       SUM(InvoiceLine.Quantity) AS QuantitySold
FROM Invoice
JOIN InvoiceLine ON InvoiceLine.InvoiceId = Invoice.InvoiceId
JOIN Track       ON Track.TrackId = InvoiceLine.TrackId
JOIN Genre       ON Genre.GenreId = Track.GenreId
WHERE Genre.GenreId = (SELECT GenreId FROM Top3Genre)
GROUP BY 1
ORDER BY 1
)


SELECT t1.Year AS Year,
       t1.Name AS Top1Name,
       t1.QuantitySold AS Top1QuantitySold,
       t2.Name AS Top2Name,
       t2.QuantitySold AS Top2QuantitySold,
       t3.Name AS Top3Name,
       t3.QuantitySold AS Top3QuantitySold
/* Tive que fazer a subquery abaixo para garantir que todas as possíveis datas estaríam na
tabela final, já que o SQLite fornecido não possui FULL OUTER JOIN ou RIGHT JOIN */
FROM (
  SELECT DISTINCT datetime(InvoiceDate, 'start of year') AS Year
  FROM Invoice
) AS FullOuterJoin
LEFT JOIN Top1ByYear AS t1 ON t1.Year = FullOuterJoin.Year
LEFT JOIN Top2ByYear AS t2 ON t1.Year = t2.Year
LEFT JOIN Top3ByYear AS t3 ON t1.Year = t3.Year
