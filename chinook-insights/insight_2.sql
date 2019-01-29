/* Gráfico 2 */
/* Query utilizada para obter trilhas que possuem duração maior que a média. */

SELECT TrackId,
       Name,
       Milliseconds
FROM Track
WHERE Milliseconds > (
  SELECT AVG(Milliseconds)
  FROM Track
)
ORDER BY 3 DESC;

/* Query para obter a média de duração das trilhas (disponibilizado como dado no slide) */
SELECT AVG(Milliseconds)
FROM Track;

