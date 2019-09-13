-- Q1:
-- filter country_id, and calculate count of distinct user_id for each site_id
SELECT 
	site_id, 
	COUNT(DISTINCT user_id)
FROM sample_data
WHERE country_id = 'BDV'
GROUP BY 1
ORDER BY COUNT(DISTINCT user_id) DESC
LIMIT 1

-- Q2:
-- filter timestamp, and count total visit for each user_id and each site_id 
SELECT
    user_id,
    site_id,
    COUNT(*)  AS visit_times
FROM sample_data
WHERE ts BETWEEN '2019-02-03 00:00:00' AND '2019-02-04 23:59:59'
GROUP BY 1,2
ORDER BY COUNT(*) DESC

-- Q3:
-- use window function to return the first visit record for each user_id, and then count frequency for each site_id
SELECT
    site_id,
    COUNT(*) AS num_users
FROM (
    SELECT
        user_id,
        site_id,
        RANK() OVER(PARTITION BY user_id ORDER BY ts DESC) AS rn
    FROM sample_data
		)
WHERE rn=1
GROUP BY 1
ORDER BY COUNT(*) DESC
LIMIT 3;

-- Q4
-- return the last visit site of each user
WITH last_site AS (
    SELECT 
        user_id, 
        site_id AS last_site_id 
    FROM (
        SELECT
            user_id,
            site_id,
            RANK() OVER(PARTITION BY user_id ORDER BY ts DESC) AS rn
        FROM sample_data
        )
    WHERE rn =1
),
-- return the first visit site of each user
first_site AS (
    SELECT 
        user_id, 
        site_id AS first_site_id 
    FROM (
        SELECT
            user_id,
            site_id,
            RANK() OVER(PARTITION BY user_id ORDER BY ts) AS rn
        FROM sample_data
        )
    WHERE rn =1
            )
SELECT
	COUNT(*) AS tot
FROM last_site ls
JOIN first_site fs
ON ls.user_id = fs.user_id
WHERE first_site_id = last_site_id                                                            