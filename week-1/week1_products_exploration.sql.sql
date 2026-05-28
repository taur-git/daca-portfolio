-- ============================================
-- Päringud:
-- Autor: [Urmas Tammekun]
-- Kuupäev: 2026-04-01
-- Eesmärk: Vastata Toomase küsimusele #1
-- ============================================

-- Duplikaatide arv sales tabelis

SELECT
    COUNT(*) AS ridu_kokku,
    COUNT(DISTINCT sale_id) AS unikaalseid
FROM sales;1

-- Mitu toodet on kokku?

SELECT COUNT(*) AS toodete_arv
FROM products;

-- Kõik unikaalsed tootekategooriad

SELECT DISTINCT category FROM products;

-- 10 kalleimat toodet

SELECT product_name, category, retail_price
FROM products
ORDER BY retail_price DESC
LIMIT 10;

 -- 10 odavamat toodet

SELECT product_name, category, retail_price    
FROM products    
ORDER BY retail_price ASC    LIMIT 10;

 -- Näita: kõik kindla kategooria tooted
 
SELECT *  FROM products   
WHERE category = 'jalanõusid'    
ORDER BY retail_price DESC

-- Puuduvad hinnad (i.e., retail_price is NULL)

SELECT COUNT(*) - COUNT(retail_price) AS puuduvad_hinnad
FROM products;

-- Puuduvad kategooriad (i.e., category is NULL)

SELECT COUNT(*) - COUNT(category) AS puuduvad_kategooriad
FROM products;

-- Toodete arv kokku

SELECT category, COUNT(*) AS toodete_arv   
FROM products   
GROUP BY category   
ORDER BY toodete_arv DESC;

-- Keskmised hinnad kategooriati

SELECT category,        
COUNT(*) AS toodete_arv,          
MIN(retail_price) AS min_hind,          
MAX(retail_price) AS max_hind   
FROM products   
GROUP BY category   
ORDER BY max_hind DESC;

-- Tooted, mille hind on üle 50 EUR konkreetses kategoorias

SELECT *  
FROM products   
WHERE retail_price > 50 AND category = 'aksessuaarid'   
ORDER BY retail_price DESC;

