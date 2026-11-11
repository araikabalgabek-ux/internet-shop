const express = require("express");
const db = require("./db");
const app = express();

app.use(express.json());

// 1. Барлық тауарларды алу (GET сұранысы)
app.get("/api/products", async (req, res) => {
 try {
     const [products] = await db.query("SELECT * FROM products");
     res.json(products);
 } catch (error) {
     res.status(500).json({ message: "Серверде қате орын алды" });
 }
});

// 2. ID бойынша нақты бір тауарды алу (GET сұранысы)
app.get("/api/products/:id", async (req, res) => {
 try {
     const [products] = await db.query("SELECT * FROM products WHERE id = ?", [req.params.id]);
     if (products.length === 0) {
         return res.status(404).json({ message: "Тауар табылмады" });
     }
     res.json(products[0]);
 } catch (error) {
     res.status(500).json({ message: "Серверде қате орын алды" });
 }
});

// 3. Жаңа тауар қосу (POST сұранысы)
app.post("/api/products", async (req, res) => {
 try {
     const { name, description, price, stock, category_id } = req.body;
     if (!name || !price || stock === undefined) {
         return res.status(400).json({ message: "Міндетті өрістерді толтырыңыз" });
     }
     const [result] = await db.query(
         `INSERT INTO products (name, description, price, stock, category_id) VALUES (?, ?, ?, ?, ?)`,
         [name, description || null, price, stock, category_id || null]
     );
     res.status(201).json({
         id: result.insertId,
         name, description, price, stock, category_id
     });
 } catch (error) {
     res.status(500).json({ message: "Тауарды қосу кезінде қате кетті" });
 }
});

// 4. Тауар ақпаратын жаңарту (PUT сұранысы)
app.put("/api/products/:id", async (req, res) => {
 try {
     const { name, description, price, stock, category_id } = req.body;
     if (!name || !price || stock === undefined) {
         return res.status(400).json({ message: "Міндетті өрістерді толтырыңыз" });
     }
     const [result] = await db.query(
         `UPDATE products SET name = ?, description = ?, price = ?, stock = ?, category_id = ? WHERE id = ?`,
         [name, description || null, price, stock, category_id || null, req.params.id]
     );
     if (result.affectedRows === 0) {
         return res.status(404).json({ message: "Тауар табылмады" });
     }
     res.json({ message: "Тауар ақпараты сәтті жаңартылды" });
 } catch (error) {
     res.status(500).json({ message: "Серверде қате орын алды" });
 }
});

// 5. Тауарды өшіру (DELETE сұранысы)
app.delete("/api/products/:id", async (req, res) => {
 try {
     const [result] = await db.query("DELETE FROM products WHERE id = ?", [req.params.id]);
     if (result.affectedRows === 0) {
         return res.status(404).json({ message: "Тауар табылмады" });
     }
     res.json({ message: "Тауар жүйеден сәтті жойылды" });
 } catch (error) {
     res.status(500).json({ message: "Серверде қате орын алды" });
 }
});

// API серверін 3000 портында іске қосу
app.listen(3000, () => {
 console.log("Интернет-дүкен API сервері іске қосылды: http://localhost:3000");
});