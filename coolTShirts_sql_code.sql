-- Geting to know the website
SELECT DISTINCT page_name
FROM page_visits;


-- Getting to know the campaigns and sources
SELECT DISTINCT utm_campaign, utm_source
FROM page_visits;

-- Number of first touches for each campaign
WITH first_touch AS(
  SELECT user_id, MIN(timestamp) AS first_touch_at
  FROM page_visits
  GROUP BY user_id),
first_touch_results AS(
  SELECT ft.user_id, ft.first_touch_at, pv.utm_campaign
  FROM first_touch AS 'ft'
  JOIN page_visits AS 'pv'
  ON ft.user_id = pv.user_id AND ft.first_touch_at = pv.timestamp)
SELECT utm_campaign, COUNT(utm_campaign)
FROM first_touch_results
GROUP BY 1
ORDER BY 2;

-- Number of last touches for each campaign
WITH last_touch AS(
  SELECT user_id, MAX(timestamp) AS last_touch_at
  FROM page_visits
  GROUP BY user_id),
last_touch_results AS(
  SELECT lt.user_id, lt.last_touch_at, pv.utm_campaign
  FROM last_touch AS 'lt'
  JOIN page_visits AS 'pv'
  ON lt.user_id = pv.user_id AND lt.last_touch_at = pv.timestamp)
SELECT utm_campaign, COUNT(utm_campaign)
FROM last_touch_results
GROUP BY 1
ORDER BY 2;

-- Number of last touches for each campaign that made a purchase
WITH last_touch AS(
  SELECT user_id, MAX(timestamp) AS last_touch_at
  FROM page_visits
  WHERE page_name = '4 - purchase'
  GROUP BY user_id),
last_touch_results AS(
  SELECT lt.user_id, lt.last_touch_at, pv.utm_campaign
  FROM last_touch AS 'lt'
  JOIN page_visits AS 'pv'
  ON lt.user_id = pv.user_id AND lt.last_touch_at = pv.timestamp)
SELECT utm_campaign, COUNT(utm_campaign)
FROM last_touch_results
GROUP BY 1
ORDER BY 2;

-- landing lurchasing combinations
WITH landings AS(
  SELECT *
  FROM page_visits
  WHERE page_name = '1 - landing_page'),
purchases AS (
  SELECT *
  FROM page_visits
  WHERE page_name = '4 - purchase'),
combined AS(
  SELECT la.timestamp AS first_touch_at, la.user_id, la.utm_campaign AS landing_utm, pu.timestamp AS last_touch_at, pu.utm_campaign AS purchase_utm
  FROM landings AS 'la'
  INNER JOIN purchases 'pu'
  ON la.user_id = pu.user_id)
SELECT DISTINCT landing_utm, purchase_utm
FROM combined
ORDER BY landing_utm;

-- Number of users where landing_utm = purchase_utm
WITH landings AS(
  SELECT *
  FROM page_visits
  WHERE page_name = '1 - landing_page'),
purchases AS (
  SELECT *
  FROM page_visits
  WHERE page_name = '4 - purchase'),
combined AS(
  SELECT la.timestamp AS first_touch_at, la.user_id, la.utm_campaign AS landing_utm, pu.timestamp AS last_touch_at, pu.utm_campaign AS purchase_utm
  FROM landings AS 'la'
  INNER JOIN purchases 'pu'
  ON la.user_id = pu.user_id)
SELECT landing_utm, purchase_utm, COUNT(user_id)
FROM combined
WHERE landing_utm = purchase_utm
GROUP BY landing_utm;
