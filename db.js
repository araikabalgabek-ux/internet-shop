const sqlite3 = require("sqlite3").verbose();
const path = require("path");

const dbPath = path.resolve(__dirname, "lab6.sqlite");
const db = new sqlite3.Database(dbPath, (err) => {
  if (err) console.error(err.message);
  else console.log("SQLite базасына сәтті қосылды.");
});

// Кестелерді lab6.sql құрылымына сай құру
db.serialize(() => {
  db.run(`
    CREATE TABLE IF NOT EXISTS categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL UNIQUE,
      description TEXT
    )
  `);

  db.run(`
    CREATE TABLE IF NOT EXISTS products (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT,
      price REAL NOT NULL,
      stock INTEGER NOT NULL,
      category_id INTEGER,
      FOREIGN KEY (category_id) REFERENCES categories(id)
    )
  `);
});

db.query = function (sql, params = []) {
  return new Promise((resolve, reject) => {
    if (sql.trim().toUpperCase().startsWith("SELECT")) {
      db.all(sql, params, (err, rows) => {
        if (err) reject(err);
        else resolve([rows]);
      });
    } else {
      db.run(sql, params, function (err) {
        if (err) reject(err);
        else resolve([{ affectedRows: this.changes, insertId: this.lastID }]);
      });
    }
  });
};

module.exports = db;