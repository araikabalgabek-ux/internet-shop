import streamlit as st
import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score

# Беттің конфигурациясы
st.set_page_config(
    page_title="Интернет-дүкен: Машиналық оқыту",
    page_icon="🛒",
    layout="centered"
)

# --- 1. ДЕРЕКТЕР ЖӘНЕ МОДЕЛЬДІ ҚҰРУ ---
X = np.array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]).reshape(-1, 1)
y = np.array([45, 50, 55, 60, 68, 72, 80, 85, 90, 95])

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

model = LinearRegression()
model.fit(X_train, y_train)

y_pred = model.predict(X_test)
mae = mean_absolute_error(y_test, y_pred)
mse = mean_squared_error(y_test, y_pred)
r2 = r2_score(y_test, y_pred)


# --- 2. STREAMLIT ВЕБ-ИНТЕРФЕЙСІ ---
st.title("🛒 Интернет-дүкен ақпараттық жүйесі")
st.subheader("Машиналық оқыту: Сызықтық регрессия арқылы болжау моделі")

st.write("Бұл модуль  жарнама бюджетіне немесе уақытқа байланысты көрсеткіштерді болжауға арналған.")

st.markdown("---")

st.markdown("### 🎛️ Болжам жасау панелі")
input_value = st.slider("Оқу уақыты / Жарнама бюджеті (сағат немесе мың тг):", 1, 10, 5)

if st.button("🚀 Нәтижені болжау", type="primary"):
    prediction = model.predict([[input_value]])[0]
    st.success(f"📈 **Болжамды нәтиже (Сатылым / Балл):** `{prediction:.2f}`")

st.markdown("---")

# --- 3. МОДЕЛДІҢ ПАРАМЕТРЛЕРІ МЕН МЕТРИКАЛАРЫ ---
st.markdown("### 📊 Модель параметрлері мен сапасын бағалау")

col1, col2 = st.columns(2)

with col1:
    st.info("**Модель коэффициенттері:**")
    st.write(f"- **Салмақ (Weight/Coef):** `{model.coef_[0]:.2f}`")
    st.write(f"- **Тұрақты (Bias/Intercept):** `{model.intercept_:.2f}`")

with col2:
    st.warning("**Сапа метрикалары:**")
    st.write(f"- **MAE:** `{mae:.2f}`")
    st.write(f"- **MSE:** `{mse:.2f}`")
    st.write(f"- **R2 Score:** `{r2:.2f}`")

st.markdown("---")

# --- 4. ГРАФИКАЛЫҚ КӨРСЕТІЛІМ ---
st.markdown("### 📉 Регрессия сызығының графигі")

fig, ax = plt.subplots(figsize=(8, 5))
ax.scatter(X, y, color="blue", label="Нақты деректер", s=70)
ax.plot(X, model.predict(X), color="red", linewidth=2, label="Регрессия сызығы")
ax.set_xlabel("Оқу уақыты / Жарнама бюджеті", fontsize=11)
ax.set_ylabel("Қорытынды балл / Сатылым көлемі", fontsize=11)
ax.set_title("Сызықтық регрессия көмегімен болжау", fontsize=13, fontweight="bold")
ax.legend(fontsize=10)
ax.grid(True, linestyle="--", alpha=0.6)

st.pyplot(fig)