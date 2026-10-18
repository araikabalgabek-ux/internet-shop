-- Специальные настройки для красивого вывода таблиц в терминале
.headers on
.mode box
PRAGMA foreign_keys = ON;

-- Удаление старых кестелер (чтобы не было конфликтов при перезапусках)
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS deliveries;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS carts;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS couriers;
DROP TABLE IF EXISTS users;

-- ========================================================
-- 1. КЕСТЕЛЕРДІ ҚҰРУ (CREATE TABLE)
-- ========================================================
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL
);

CREATE TABLE categories (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255)
);

CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    price NUMERIC(10,2) NOT NULL CHECK (price > 0),
    stock INTEGER NOT NULL CHECK (stock >= 0),
    category_id INTEGER NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE carts (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE orders (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    date TIMESTAMP NOT NULL,
    status VARCHAR(30) NOT NULL,
    total_amount NUMERIC(10,2) NOT NULL CHECK (total_amount >= 0),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE order_items (
    id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    price NUMERIC(10,2) NOT NULL CHECK (price > 0),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE couriers (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(30) NOT NULL
);

CREATE TABLE deliveries (
    id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    address VARCHAR(255) NOT NULL,
    status VARCHAR(30) NOT NULL,
    courier_id INTEGER,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (courier_id) REFERENCES couriers(id)
);

CREATE TABLE payments (
    id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    amount NUMERIC(10,2) NOT NULL CHECK (amount > 0),
    method VARCHAR(30) NOT NULL,
    status VARCHAR(30) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- ========================================================
-- 2. МӘЛІМЕТТЕРДІ ЕНГІЗУ (INSERT INTO)
-- ========================================================
INSERT INTO users (id, name, email, password, role) VALUES
(1, 'Арай Балғабек', 'arai@gmail.com', '12345', 'customer'),
(2, 'Admin User', 'admin@gmail.com', 'admin123', 'admin'),
(3, 'Марат Оспанов', 'marat@gmail.com', 'qwerty', 'customer');

INSERT INTO categories (id, name, description) VALUES
(1, 'Ноутбуктер', 'Ноутбуктер мен компьютерлер'),
(2, 'Телефондар', 'Смартфондар мен телефондар'),
(3, 'Құлаққаптар', 'Сымсыз және сымды құлаққаптар');

INSERT INTO products (id, name, description, price, stock, category_id) VALUES
(1, 'MacBook Air', 'Apple ноутбугі', 500000.00, 10, 1),
(2, 'iPhone 15', 'Apple смартфоны', 400000.00, 15, 2),
(3, 'AirPods', 'Сымсыз құлаққап', 80000.00, 20, 3);

INSERT INTO carts (id, user_id, created_at) VALUES
(1, 1, CURRENT_TIMESTAMP);

INSERT INTO orders (id, user_id, date, status, total_amount) VALUES
(1, 1, CURRENT_TIMESTAMP, 'Жаңа', 580000.00),
(2, 3, CURRENT_TIMESTAMP, 'Жеткізілді', 400000.00);

INSERT INTO order_items (id, order_id, product_id, quantity, price) VALUES
(1, 1, 1, 1, 500000.00),
(2, 1, 3, 1, 80000.00),
(3, 2, 2, 1, 400000.00);

INSERT INTO couriers (id, name, phone) VALUES
(1, 'Ерлан Қасымов', '+77001234567'),
(2, 'Данияр Сәрсенов', '+77007654321');

INSERT INTO deliveries (id, order_id, address, status, courier_id) VALUES
(1, 1, 'Алматы, Абая көшесі 10', 'Жолда', 1),
(2, 2, 'Алматы, Достық көшесі 25', 'Жеткізілді', 2);

INSERT INTO payments (id, order_id, amount, method, status) VALUES
(1, 1, 580000.00, 'Kaspi', 'Төленді'),
(2, 2, 400000.00, 'Карта', 'Төленді');

-- ========================================================
-- 4. МӘЛІМЕТТІ ӨЗГЕРТУ (UPDATE)
-- ========================================================
UPDATE products SET price = 520000.00 WHERE id = 1;

-- ========================================================
-- 5. МӘЛІМЕТТІ ӨШІРУ (DELETE)
-- ========================================================
INSERT INTO products (id, name, description, price, stock, category_id)
VALUES (4, 'Test Product', 'DELETE үшін тест өнім', 1000.00, 1, 1);

DELETE FROM products WHERE id = 4;

-- ========================================================
-- 3 & 6. МӘЛІМЕТТЕРДІ ТЕКСЕРУ ЖӘНЕ БАЙЛАНЫСТАР (SELECT & JOIN)
-- ========================================================
SELECT '--- 3. ТАУАРЛАР КЕСТЕСІ (PRODUCTS) ---' AS '';
SELECT * FROM products;

SELECT '--- 6. USER МЕН ORDER БАЙЛАНЫСЫ (JOIN) ---' AS '';
SELECT users.name, orders.id, orders.status, orders.total_amount
FROM users
JOIN orders ON users.id = orders.user_id;

SELECT '--- 6. PRODUCT МЕН CATEGORY БАЙЛАНЫСЫ (JOIN) ---' AS '';
SELECT products.name AS product, categories.name AS category, products.price
FROM products
JOIN categories ON products.category_id = categories.id;