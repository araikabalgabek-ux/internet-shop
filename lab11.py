import sqlite3

# БАР ДЕРЕКТЕР БАЗАСЫМЕН БАЙЛАНЫСУ
# (Егер файл аты 'shop.db' болмаса, тырнақша ішіне өзіңіздің база файлыңыздың атын жазыңыз)
db_name = "shop.db" 

conn = sqlite3.connect(db_name)
cursor = conn.cursor()

print(f"=== '{db_name}' ДЕРЕКТЕР БАЗАСЫМЕН БАЙЛАНЫС СӘТТІ ОРНАТЫЛДЫ ===\n")

# ==========================================================
# 1-БӨЛІМ: ТАУАРДЫ ІЗДЕУ (SQL Injection және Қорғаныс)
# ==========================================================
print("--- [1-БӨЛІМ] Тауар іздеуді тексеру ---")

# 1.1 Осал іздеу (Шабуыл: ' OR 1=1 --)
term_vuln = input("Тауар атауын енгізіңіз: ")
query_vuln = f"SELECT * FROM products WHERE name = '{term_vuln}'"
print("Орындалған сұраныс:", query_vuln)

try:
    cursor.execute(query_vuln)
    res_vuln = cursor.fetchall()
    if res_vuln:
        print("Нәтиже (Шабуыл сәтті өтті):", res_vuln)
    else:
        print("Тауар табылмады!")
except Exception as e:
    print("Қате:", e)

# 1.2 Қауіпсіз іздеу (Қорғаныс орнату)
term_safe = input("\nТауар атауын қайта енгізіңіз (Қауіпсіз тексеру): ")
query_safe = "SELECT * FROM products WHERE name = ?"
cursor.execute(query_safe, (term_safe,))
res_safe = cursor.fetchall()

if res_safe:
    print("Нәтиже табылды:", res_safe)
else:
    print("Тауар табылмады немесе шабуыл бұғатталды!")

print("\n" + "="*50 + "\n")

# ==========================================================
# 2-БӨЛІМ: ЖҮЙЕГЕ КІРУ / АВТОРИЗАЦИЯ (Логин мен Пароль)
# ==========================================================
print("--- [2-БӨЛІМ] Жүйеге кіруді тексеру ---")

# 2.1 Осал логин (Шабуыл: ' OR 1=1 --)
name_vuln = input("Атыңызды немесе Логин енгізіңіз: ")
password_vuln = input("Пароль енгізіңіз: ")

# (Егер кестеңізде баған аты 'name' емес, 'username' болса, төмендегі 'name'-ді 'username'-ге ауыстырыңыз)
query_login_vuln = f"SELECT * FROM users WHERE name = '{name_vuln}' AND password = '{password_vuln}'"
print("Орындалған сұраныс:", query_login_vuln)

try:
    cursor.execute(query_login_vuln)
    user_res_vuln = cursor.fetchone()
    if user_res_vuln:
        print("Нәтиже: Жүйеге кіру сәтті орындалды!")
    else:
        print("Нәтиже: Логин немесе пароль қате!")
except Exception as e:
    print("Қате:", e)

# 2.2 Қауіпсіз логин (Параметрленген сұраныс)
name_safe = input("\nАтыңызды немесе Логин қайта енгізіңіз (Қауіпсіз тексеру): ")
password_safe = input("Пароль енгізіңіз: ")

query_login_safe = "SELECT * FROM users WHERE name = ? AND password = ?"
cursor.execute(query_login_safe, (name_safe, password_safe))
user_res_safe = cursor.fetchone()

if user_res_safe:
    print("Нәтиже: Жүйеге кіру сәтті орындалды!")
else:
    print("Нәтиже: Логин немесе пароль қате немесе шабуыл бұғатталды!")

conn.close()
print("\n=== БАРЛЫҚ ТАПСЫРМАЛАР АЯҚТАЛДЫ ===")