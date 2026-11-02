const mysql = require("mysql2/promise");

const pool = mysql.createPool({
 host: "localhost",
 user: "root",
 password: "YOUR_PASSWORD", // ⚠️ ОСЫ ЖЕРГЕ ӨЗ MySQL ПАРОЛІҢІЗДІ ЖАЗЫҢЫЗ
 database: "ecommerce_db",  // Интернет-дүкен дерекқорының атауы
 waitForConnections: true,
 connectionLimit: 10
});

module.exports = pool;
