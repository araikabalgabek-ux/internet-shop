.headers on
.mode box


SELECT '--- 1. Бірнеше кестені JOIN арқылы біріктіру (Тапсырыс толық құрамы) ---' AS '';
-- Үш кестені біріктіріп, клиенттің атын, тауардың атын, санын және бағасын шығару
SELECT users.name AS 'Клиент', products.name AS 'Тауар', order_items.quantity AS 'Саны', order_items.price AS 'Бағасы'
FROM order_items
JOIN orders ON order_items.order_id = orders.id
JOIN users ON orders.user_id = users.id
JOIN products ON order_items.product_id = products.id;


SELECT '--- 2. Бір жолды және бір бағанды ішкі сұраныс (Ең қымбат тауардан кейінгі өнімдер) ---' AS '';
-- Ішкі сұраныс ең қымбат тауардың бағасының жартысын есептейді, ал негізгі сұраныс содан қымбат тауарларды табады
SELECT name, price FROM products
WHERE price > (SELECT MAX(price) / 2 FROM products);


SELECT '--- 3. Бірнеше жолды ішкі сұраныс (IN операторымен жұмыс) ---' AS '';
-- Санатында 'Ноутбуктер' немесе 'Телефондар' бар барлық тауарларды ішкі сұраныс арқылы тізіп шығару
SELECT name, price, stock FROM products
WHERE category_id IN (SELECT id FROM categories WHERE name = 'Ноутбуктер' OR name = 'Телефондар');


SELECT '--- 4. CASE арқылы шартты мәндер қалыптастыру (Тауар қорының статусы) ---' AS '';
-- Қоймадағы тауар санына байланысты автоматты түрде мәтіндік статус беру
SELECT name, stock,
    CASE 
        WHEN stock >= 20 THEN 'Қоймада жеткілікті'
        WHEN stock BETWEEN 11 AND 19 THEN 'Тауар азайып жатыр'
        ELSE 'Шұғыл тапсырыс беру керек!'
    END AS 'Қойма статусы'
FROM products;


SELECT '--- 5. Күрделі аналитикалық сұраныс (Клиенттердің белсенділігі мен топтау) ---' AS '';
-- JOIN, GROUP BY және CASE операторларын біріктіріп, клиенттердің сатып алу деңгейін анықтау
SELECT users.name AS 'Клиент аты', COUNT(orders.id) AS 'Тапсырыс саны', SUM(orders.total_amount) AS 'Жалпы сомасы',
    CASE 
        WHEN SUM(orders.total_amount) >= 500000 THEN 'VIP Клиент'
        ELSE 'Қатарлы сатып алушы'
    END AS 'Клиент дәрежесі'
FROM users
JOIN orders ON users.id = orders.user_id
GROUP BY users.id;
