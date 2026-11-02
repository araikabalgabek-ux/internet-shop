# Интернет-дүкен ақпараттық жүйесінің үш деңгейлі архитектурасы (Көптілді стек)

```mermaid
graph TD
    %% Стильдер
    classDef actorStyle fill:#f9f,stroke:#333,stroke-width:2px;
    classDef presentation fill:#bbf,stroke:#333,stroke-width:2px;
    classDef logic fill:#f96,stroke:#333,stroke-width:2px;
    classDef access fill:#ff9,stroke:#333,stroke-width:2px;
    classDef database fill:#6c6,stroke:#333,stroke-width:2px;

    %% 1. Презентация деңгейі
    subgraph Presentation_Layer [1. Презентация деңгейі - JavaScript / TypeScript]
        Customer[👤 Сатып алушы / Актер]:::actorStyle
        Admin[👮 Әкімші / Актер]:::actorStyle
        UI[💻 Пайдаланушы интерфейсі <br> Веб-сайт, Формалар, Мобильді қосымша <br> Технологиялар: HTML5, CSS3, React / Vue.js]:::presentation
    end

    %% 2. Қолданбалы логика деңгейі
    subgraph Application_Layer [2. Қолданбалы логика деңгейі - Java / Python / C#]
        Auth[🔐 Авторизация модулі]:::logic
        Catalog[🛍️ Тауарлар каталогы]:::logic
        Cart[🛒 Тапсырыс беру модулі]:::logic
        AdminPanel[📊 Басқару модулі]:::logic
        Notify[🔔 Хабарландыру қызметі]:::logic
    end

    %% 3. Деректер деңгейі
    subgraph Data_Layer [3. Деректер деңгейі - SQL]
        DAC[🔄 Деректерге қол жеткізу компоненті <br> SQL сұраныстарды қалыптастыру]:::access
        
        %% Реляциялық дерекқор құрылымы
        T_Users["🗄️ Users кестесі <br> (PostgreSQL / MySQL)"]:::database
        T_Products["🗄️ Products кестесі <br> (PostgreSQL / MySQL)"]:::database
        T_Orders["🗄️ Orders кестесі <br> (PostgreSQL / MySQL)"]:::database
    end

    %% Блоктарды мәжбүрлі түрде тігінен (вертикальді) қатарға тұрғызу
    Presentation_Layer --> Application_Layer
    Application_Layer --> Data_Layer

    %% Нақты функционалды байланыстар
    Customer -->|1. User Action / Сайтқа кіреді| UI
    Admin -->|1. Admin Action / Панельге кіреді| UI
    
    %% 1-деңгей мен 2-деңгей арасындағы HTTPS Протоколы және Сұраныстар (Ағылшынша)
    UI -->|2. HTTPS POST Request / Login| Auth
    UI -->|2. HTTPS GET Request / Search| Catalog
    UI -->|2. HTTPS POST Request / Checkout| Cart
    UI -->|2. HTTPS PUT Request / Manage| AdminPanel

    %% Ішкі логикалық байланыс
    Cart -.->|Internal Notification Event| Notify
    
    %% 2-деңгей мен 3-деңгей арасындағы TCP/IP (Database Driver Connection) және SQL
    Auth -->|3. Data Access Call| DAC
    Catalog -->|3. Data Access Call| DAC
    Cart -->|3. Data Access Call| DAC
    AdminPanel -->|3. Data Access Call| DAC
    
    %% DAC компонентінен реляциялық кестелерге SQL Query жолдау
    DAC -->|4. SQL SELECT / INSERT Query| T_Users
    DAC -->|4. SQL SELECT Query| T_Products
    DAC -->|4. SQL INSERT Query| T_Orders
    
    %% Кестелерден DAC-қа жауап қайтару
    T_Users -.->|5. Database Data Response| DAC
    T_Products -.->|5. Database Data Response| DAC
    T_Orders -.->|5. Database Data Response| DAC
    
    %% DAC-тан логика деңгейіне деректерді қайтару
    DAC -->|6. Processed Data Result| Auth
    DAC -->|6. Processed Data Result| Catalog
    DAC -->|6. Processed Data Result| Cart
    DAC -->|6. Processed Data Result| AdminPanel
    
    %% 2-деңгейден 1-деңгейге HTTPS Response (Жауап) қайтару
    Catalog -->|7. HTTPS 200 OK Response / Product List| UI
    Cart -->|7. HTTPS 201 Created Response / Order Status| UI
    AdminPanel -->|7. HTTPS 200 OK Response / Updated Data| UI
    
    %% Пайдаланушыға соңғы визуалды жауапты көрсету
    UI -->|8. Render View to UI / Көру| Customer
    UI -->|8. Render View to UI / Көру| Admin
```