/* Gráfico 3 */
/* Query utilizada para obter top 10 de artistas de que tiveram mais trilhas vendidas no período dentre 2012 e 2013. */
SELECT Artist.ArtistId,
       Artist.Name,
       SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) AS AmountUsdSold,
       SUM(InvoiceLine.Quantity) AS QuantitySold
FROM Artist
INNER JOIN Album       ON Album.ArtistId = Artist.ArtistId
INNER JOIN Track       ON Track.AlbumId = Album.AlbumId
INNER JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
INNER JOIN Invoice     ON Invoice.InvoiceId = InvoiceLine.InvoiceId
WHERE Invoice.InvoiceDate BETWEEN '2012-01-01 00:00:00' AND '2013-12-31 23:59:59'
GROUP BY 1,2
ORDER BY 3 DESC,4 DESC
LIMIT 10;

