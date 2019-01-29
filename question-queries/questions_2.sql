--Pergunta 1
--Use sua consulta para retornar o e-mail, nome, sobrenome e gênero de todos os ouvintes de Rock. Retorne sua lista ordenada alfabeticamente por endereço de e-mail, começando por A. Você consegue encontrar um jeito de lidar com e-mails duplicados para que ninguém receba vários e-mails?

--Eu escolhi linkar as informações das tabelas Customer (cliente), Invoice (fatura), InvoiceLine (linha de faturamento), Track (música) e Genre (gênero), mas você pode encontrar outra forma de obter a informação.

SELECT DISTINCT c.Email,
                c.FirstName,
                c.LastName,
                g.Name
FROM Customer AS c
INNER JOIN Invoice AS i ON i.CustomerId = c.CustomerId
INNER JOIN InvoiceLine AS il ON il.InvoiceId = i.InvoiceId
INNER JOIN Track AS t ON t.TrackId = il.TrackId
INNER JOIN Genre AS g ON g.GenreId = t.GenreId
WHERE g.Name = 'Rock'
ORDER BY 1;

--Pergunta 2: Quem está escrevendo as músicas de rock?
--Agora que sabemos que nossos clientes amam rock, podemos decidir quais músicos convidar para tocar no show.

--Vamos convidar os artistas que mais escreveram as músicas de rock em nosso banco de dados. Escreva uma consulta que retorna o nome do Artist (artista) e a contagem total de músicas das dez melhores bandas de rock.

--Você precisará usar as tabelas Genre (gênero), Track (música) , Album (álbum), and Artist (artista).

SELECT Artist.ArtistId,
       Artist.Name,
       COUNT(*) AS NumberOfTracks
FROM Artist
INNER JOIN Album ON Album.ArtistId = Artist.ArtistId
INNER JOIN Track ON Track.AlbumId = Album.AlbumId
INNER JOIN Genre ON Genre.GenreId = Track.GenreId
WHERE Genre.Name = 'Rock'
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10;

--Pergunta 3
--Primeiro, descubra qual artista ganhou mais de acordo com InvoiceLines (linhas de faturamento)?

--Agora use este artista para encontrar qual cliente gastou mais com este artista.

--Para essa consulta, você precisará usar as tabelas Invoice (fatura), InvoiceLine (linha de faturamento), Track (música), Customer (cliente), Album (álbum) e Artist (artista).

--Observe que essa é complicada porque a quantia Total gasta na tabela Invoice (fatura) pode não ser em um só produto, então você precisa usar a tabela InvoiceLine (linha de faturamento) para descobrir quanto de cada produto foi comprado e, então, multiplicar isso pelo preço de cada artista.

WITH
BestSellerArtist AS (
  SELECT ArtistId
  FROM (
    SELECT Artist.ArtistId AS ArtistId,
           SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) AS AmountGained
    FROM Artist
    INNER JOIN Album       ON Album.ArtistId = Artist.ArtistId
    INNER JOIN Track       ON Track.AlbumId = Album.AlbumId
    INNER JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 1
  )
)

SELECT Artist.Name AS ArtistName,
     Customer.CustomerId,
       Customer.FirstName || ' ' || Customer.LastName AS FullName,
     SUM (InvoiceLine.UnitPrice * InvoiceLine.Quantity) AS AmountSpent
FROM Customer
INNER JOIN Invoice     ON Invoice.CustomerId = Customer.CustomerId
INNER JOIN InvoiceLine ON InvoiceLine.InvoiceId = Invoice.InvoiceId
INNER JOIN Track       ON Track.TrackId = InvoiceLine.TrackId
INNER JOIN Album       ON Album.AlbumId = Track.AlbumId
INNER JOIN Artist      ON Artist.ArtistId = Album.ArtistId
WHERE Artist.ArtistId = (SELECT * FROM BestSellerArtist)
GROUP BY 1,2,3
ORDER BY 4 DESC;
