-- conversion rates of questionnaire
SELECT question, COUNT(question)
FROM survey
GROUP BY question;

-- responses to questionnaire
SELECT question, response, COUNT(response)
FROM survey
GROUP BY question, response
ORDER BY question, COUNT(response) DESC;

-- funnel analysis of purchasing process
WITH funnels AS (
  SELECT DISTINCT q.user_id, h.user_id IS NOT
  NULL AS ‘home_try_on’, p.user_id IS NOT NULL
  AS ‘purchased’, h.number_of_pairs
  FROM quiz AS ‘q’
  LEFT JOIN home_try_on AS ‘h’
    ON q.user_id = h.user_id
  LEFT JOIN purchase AS ‘p’
    ON h.user_id = p.user_id)
SELECT COUNT(*) AS ‘quiz_participants’, SUM(home_try_on) AS ‘num_home_try_on’, SUM(purchased) AS ‘num_purchased’, 100 * SUM(home_try_on) / COUNT(*) AS quiz_to_home_try_on, 100 * SUM(purchased) / SUM(home_try_on) AS ‘home_try_on_to_purchased’
FROM funnels;

-- A/B analysis of the number of glasses sent to consumer's homes
WITH funnels AS (
  SELECT DISCTINCT q.user_id, h.user_id IS NOT
  NULL AS ‘home_try_on’, p.user_id IS NOT NULL
  AS ‘purchased’, h.number_of_pairs
  FROM quiz AS ‘q’
  LEFT JOIN home_try_on AS ‘h’
    ON q.user_id = h.user_id
  LEFT JOIN purchase AS ‘p’
    ON h.user_id = p.user_id)
SELECT number_of_pairs, SUM(home_try_on) AS ‘num_home_try_on’, SUM(purchased) AS ‘num_purchased’, 100 * SUM(purchased) / SUM(home_try_on) AS ‘home_try_on_to_purchased’
FROM funnels
GROUP BY number_of_pairs;

-- purchase analysis by style
SELECT style, COUNT(style), ROUND(AVG(price),2)
FROM purchase
GROUP BY style;

-- purchase analysis by color
SELECT color, COUNT(color), ROUND(AVG(price),2)
FROM purchase
GROUP BY color;

-- purchase analysis by price
SELECT price, COUNT(price)
FROM purchase
GROUP BY price;







