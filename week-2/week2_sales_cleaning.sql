CREATE TABLE sales_test AS SELECT * FROM sales;   --Loome test koopia 

-- Kontrolli ridade arvu
SELECT COUNT(*) AS ridade_arv FROM sales_test; -- ridade arv 15234

--Leia duplikaadid — millised tellimused korduvad?
SELECT sale_id, COUNT(*) AS koopiate_arv
FROM sales_test
GROUP BY sale_id
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;

-- Loe kokku duplikaatsete ridade arv:
SELECT COUNT(*) AS duplikaat_read
FROM sales_test
WHERE id NOT IN (
    SELECT MIN(id)
    FROM sales_test
    GROUP BY sale_id
);

-- Leia NULL väärtused kriitilistes väljades:
SELECT
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer_id,
    COUNT(*) FILTER (WHERE sale_date IS NULL) AS null_sale_date,
    COUNT(*) FILTER (WHERE total_price IS NULL) AS null_total_price
FROM sales_test;

--Kontrolli kuupäevade formaati — kas on tuleviku kuupäevi?
SELECT COUNT(*) AS tuleviku_kuupaevad
FROM sales_test
WHERE sale_date > CURRENT_DATE;

