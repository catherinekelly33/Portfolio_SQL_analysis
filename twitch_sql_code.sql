-- Unique games
SELECT DISTINCT game
FROM stream;

-- Unique channels
SELECT DISTINCT channel
FROM stream;

-- Popularity of games
SELECT game, COUNT(time)
FROM stream
GROUP BY 1
ORDER BY 2 DESC;

-- Location of League of Legends viewers
SELECT country, COUNT(time)
FROM stream
WHERE game = 'League of Legends'
GROUP BY 1
ORDER BY 2 DESC;

-- Steaming sites
SELECT player, COUNT(time)
FROM stream
GROUP BY 1
ORDER BY 2 DESC;

-- Add genre to games
SELECT game,
 CASE
  WHEN game = 'League of Legends' THEN 'MOBA' 
  WHEN game = 'Dota 2' THEN 'MOBA'
  WHEN game = 'Heros of the Storm' THEN 'MOBA'
  WHEN game = 'Counter-Strike: Global Offensive' THEN 'FPS'
  WHEN game = 'DayZ' THEN 'Survival'
  WHEN game = 'ARK: Survival Evolved' THEN 'Survival'
  ELSE 'Other'
  END AS 'genre',
  COUNT(*)
FROM stream
GROUP BY 1
ORDER BY 3 DESC;

-- Count of users by hour in the UK
SELECT strftime('%H', time), COUNT(*)
FROM stream
WHERE country = 'GB'
GROUP BY 1
ORDER BY 1;