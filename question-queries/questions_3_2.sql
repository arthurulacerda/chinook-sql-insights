--Pergunta 2
--Retorne todos os nomes de músicas que possuem um comprimento de canção maior que o comprimento médio de canção. Embora você possa fazer isso com duas consultas. Imagine que você queira que sua consulta atualize com base em onde os dados são colocados no banco de dados. Portanto, você não quer fazer um hard code da média na sua consulta. Você só precisa da tabela Track (música) para completar essa consulta.

--Retorne o Name (nome) e os Milliseconds (milissegundos) para cada música. Ordene pelo comprimento da canção com as músicas mais longas sendo listadas primeiro.

SELECT TrackId,
       Name,
       Milliseconds
FROM Track
WHERE Milliseconds > (
  SELECT AVG(Milliseconds)
  FROM Track
)
ORDER BY 3 DESC;
