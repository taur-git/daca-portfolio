--Join sales customers
SELECT
    c.first_name,
    c.last_name,
    c.email,
    c.city,
    s.sale_id,
    s.sale_date,
    s.total_price
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
LIMIT 20;

--Leia TOP10 klienti kogumüügi järgi
SELECT
    c.first_name || ' ' || c.last_name AS klient,
    c.city,
    COUNT(DISTINCT s.sale_id) AS ostude_arv,
    SUM(s.total_price)        AS kogumüük
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.city
ORDER BY kogumüük DESC
LIMIT 10;

--Müük linnade kaupa
SELECT
    c.city,
    COUNT(DISTINCT c.customer_id) AS kliente,
    COUNT(s.sale_id)              AS oste,
    SUM(s.total_price)            AS kogumüük
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.city
ORDER BY kogumüük DESC;

--Uuri loyalty tier jaotust
SELECT
    c.loyalty_tier,
    COUNT(DISTINCT c.customer_id) AS kliente,
    COUNT(s.sale_id)              AS oste,
    SUM(s.total_price)            AS kogumüük,
    ROUND(AVG(s.total_price), 2)  AS kesk_ost
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.loyalty_tier
ORDER BY kogumüük DESC;