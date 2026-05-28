--Kliendigruppide analüüs CTE-ga
WITH kliendi_kokkuvõte AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS klient,
        c.city,
        c.loyalty_tier,
        COUNT(DISTINCT s.sale_id)        AS ostude_arv,
        SUM(s.total_price)               AS kogumüük,
        ROUND(AVG(s.total_price), 2)     AS kesk_ost,
        MIN(s.sale_date)                 AS esimene_ost,
        MAX(s.sale_date)                 AS viimane_ost
    FROM sales s
    INNER JOIN customers c ON s.customer_id = c.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.city, c.loyalty_tier
),
kliendi_segmendid AS (
    SELECT *,
        CASE
            WHEN kogumüük >= 1000 AND ostude_arv >= 5 THEN 'VIP'
            WHEN kogumüük >= 500  AND ostude_arv >= 3 THEN 'Kasvav'
            WHEN ostude_arv = 1                       THEN 'Ühekordne'
            ELSE 'Tavaline'
        END AS segment
    FROM kliendi_kokkuvõte
)
SELECT
    segment,
    COUNT(*)                        AS kliente,
    ROUND(AVG(kogumüük), 2)         AS kesk_kogumüük,
    ROUND(AVG(kesk_ost), 2)         AS kesk_ost,
    ROUND(AVG(ostude_arv), 1)       AS kesk_ostude_arv
FROM kliendi_segmendid
GROUP BY segment
ORDER BY kesk_kogumüük DESC;

--TOP10 klienti
SELECT
    c.first_name || ' ' || c.last_name AS klient,
    c.city,
    c.loyalty_tier,
    COUNT(DISTINCT s.sale_id)      AS ostude_arv,
    SUM(s.total_price)             AS kogumüük,
    ROUND(AVG(s.total_price), 2)   AS kesk_ost
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.city, c.loyalty_tier
ORDER BY kogumüük DESC
LIMIT 10;

--Segmentide koondstatistika
WITH kliendi_kokkuvõte AS (
    SELECT
        c.customer_id,
        c.loyalty_tier,
        COUNT(DISTINCT s.sale_id)    AS ostude_arv,
        SUM(s.total_price)           AS kogumüük,
        ROUND(AVG(s.total_price), 2) AS kesk_ost
    FROM sales s
    INNER JOIN customers c ON s.customer_id = c.customer_id
    GROUP BY c.customer_id, c.loyalty_tier
),
segmendid AS (
    SELECT *,
        CASE
            WHEN kogumüük >= 1000 AND ostude_arv >= 5 THEN 'VIP'
            WHEN kogumüük >= 500  AND ostude_arv >= 3 THEN 'Kasvav'
            WHEN ostude_arv = 1                       THEN 'Ühekordne'
            ELSE 'Tavaline'
        END AS segment
    FROM kliendi_kokkuvõte
)
SELECT
    segment,
    COUNT(*)                                    AS kliente,
    SUM(kogumüük)                               AS kogu_käive,
    ROUND(AVG(kogumüük), 2)                     AS kesk_kogumüük,
    ROUND(AVG(kesk_ost), 2)                     AS kesk_ost,
    ROUND(AVG(ostude_arv), 1)                   AS kesk_ostude_arv,
    ROUND(100.0 * SUM(kogumüük)
          / SUM(SUM(kogumüük)) OVER (), 1)      AS kaive_osakaal_pct
FROM segmendid
GROUP BY segment
ORDER BY kogu_käive DESC;