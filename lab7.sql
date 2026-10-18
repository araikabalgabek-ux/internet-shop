.headers on
.mode box

-- ========================================================
-- І БӨЛІМ: НЕГІЗГІ ТАПСЫРМАЛАР (1-8 ҚАДАМДАР)
-- ========================================================

SELECT '--- 1. SELECT арқылы қажетті мәліметтерді алу ---' AS '';
SELECT name, role FROM users;

SELECT '--- 2. WHERE арқылы мәліметтерді сүзгілеу ---' AS '';
SELECT name, price FROM products WHERE price > 100000;

SELECT '--- 3. Бірнеше шарттарды бірге қолдану (AND/OR) ---' AS '';
SELECT name, price, stock FROM products WHERE price > 100000 AND stock > 12;

SELECT '--- 4. DISTINCT арқылы қайталанатын мәндерді жою ---' AS '';
SELECT DISTINCT status FROM orders;

SELECT '--- 5. ORDER BY арқылы сұрыптау ---' AS '';
SELECT name, price FROM products ORDER BY price DESC;

SELECT '--- 6. GROUP BY арқылы мәліметтерді топтау ---' AS '';
SELECT status, COUNT(id) AS 'Тапсырыс саны' FROM deliveries GROUP BY status;

SELECT '--- 7. Агрегаттық функцияларды қолдану (SUM, AVG, MAX, MIN) ---' AS '';
SELECT 
    MAX(price) AS 'Ең қымбат тауар', 
    MIN(price) AS 'Ең арзан тауар', 
    AVG(price) AS 'Орташа баға' 
FROM products;

SELECT '--- 8. HAVING арқылы топталған нәтижелерді сүзгілеу ---' AS '';
SELECT user_id, SUM(total_amount) AS 'Жалпы сомасы' FROM orders GROUP BY user_id HAVING SUM(total_amount) > 500000;


-- ========================================================
-- ІІ БӨЛІМ: 5 ПРАКТИКАЛЫҚ АНАЛИТИКАЛЫҚ СҰРАНЫС
-- ========================================================

SELECT '--- АНАЛИТИКА 1: Әр санаттағы (category) тауарлар санын анықтау ---' AS '';
SELECT category_id, COUNT(id) AS 'Тауар саны' FROM products GROUP BY category_id;

SELECT '--- АНАЛИТИКА 2: Орташа бағадан қымбат тауарларды анықтау ---' AS '';
SELECT name, price FROM products WHERE price > (SELECT AVG(price) FROM products) ORDER BY price DESC;

SELECT '--- АНАЛИТИКА 3: Белгілі бір кезеңдегі (бүгінгі) тапсырыстар санын анықтау ---' AS '';
SELECT COUNT(id) AS 'Бүгінгі тапсырыстар саны' FROM orders WHERE date >= date('now') AND status != 'Бас тартылды';

SELECT '--- АНАЛИТИКА 4: Тапсырыстарда кездесетін бірегей статустар тізімі ---' AS '';
SELECT DISTINCT status AS 'Қолданыстағы статустар' FROM orders;

SELECT '--- АНАЛИТИКА 5: Жалпы тапсырыс сомасы 450,000-нан асатын пайдаланушыларды табу ---' AS '';
SELECT user_id, SUM(total_amount) AS 'Жалпы сомасы' FROM orders GROUP BY user_id HAVING SUM(total_amount) > 450000;