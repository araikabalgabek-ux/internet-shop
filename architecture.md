# Интернет-дүкен ақпараттық жүйесінің үш деңгейлі архитектурасы

```mermaid
graph TD
    %% Стильдер
    classDef actorStyle fill:#f9f,stroke:#333,stroke-width:2px;
    classDef presentation fill:#bbf,stroke:#333,stroke-width:2px;
    classDef logic fill:#f96,stroke:#333,stroke-width:2px;
    classDef access fill:#ff9,stroke:#333,stroke-width:2px;
    classDef database fill:#6c6,stroke:#333,stroke-width:2px;

    %% 1. Презентация деңгейі
    subgraph Presentation_Layer [1. Презентация деңгейі]
        Customer[👤 Сатып алушы / Актер]:::actorStyle
        Admin[👮 Әкімші / Актер]:::actorStyle
        UI[💻 Пайдаланушы интерфейсі <br> Веб-сайт, Формалар, Мобильді қосымша]:::presentation
    end

    %% 2. Қолданбалы логика деңгейі
    subgraph Application_Layer [2. Қолданбалы логика деңгейі]
        Auth[🔐 Авторизация модулі]:::logic
        Catalog[🛍️ Тауарлар каталогы]:::logic
        Cart[🛒 Тапсырыс беру модулі]:::logic
        AdminPanel[📊 Басқару модулі]:::logic
        Notify[🔔 Хабарландыру қызметі]:::logic
    end

    %% 3. Деректер деңгейі
    subgraph Data_Layer [3. Деректер деңгейі]
        DAC[🔄 Деректерге қол жеткізу компоненті]:::access
        
        %% Реляциялық дерекқор құрылымы
        T_Users["🗄️ Users кестесі <br> (Логин, Пароль, Рөл)"]:::database
        T_Products["🗄️ Products кестесі <br> (Атауы, Бағасы, Саны)"]:::database
        T_Orders["🗄️ Orders кестесі <br> (Тапсырыстар тарихы)"]:::database
    end

    %% Блоктарды мәжбүрлі түрде тігінен (вертикальді) қатарға тұрғызу
    Presentation_Layer --> Application_Layer
    Application_Layer --> Data_Layer

    %% Нақты функционалды байланыстар
    Customer -->|1. Сайтқа кіреді| UI
    Admin -->|1. Панельге кіреді| UI
    
    UI -->|2. Сұраныс жолдау| Auth
    UI -->|2. Іздеу| Catalog
    UI -->|2. Тапсырыс беру| Cart
    UI -->|2. Басқару| AdminPanel

    Auth -->|3. Өңдеу| DAC
    Catalog -->|3. Өңдеу| DAC
    Cart -->|3. Өңдеу| DAC
    AdminPanel -->|3. Өңдеу| DAC
    
    Cart -.->|Хабарлау| Notify
    
    %% DAC компонентінен реляциялық кестелерге сұраныс жолдау
    DAC -->|4. Query| T_Users
    DAC -->|4. Query| T_Products
    DAC -->|4. Query| T_Orders
    
    %% Кестелерден DAC-қа жауап қайтару
    T_Users -.->|5. Response| DAC
    T_Products -.->|5. Response| DAC
    T_Orders -.->|5. Response| DAC
    
    DAC -->|6. Жауап қайтару| Auth
    DAC -->|6. Жауап қайтару| Catalog
    DAC -->|6. Жауап қайтару| Cart
    DAC -->|6. Жауап қайтару| AdminPanel
    
    Catalog -->|7. HTTP Жауап| UI
    Cart -->|7. HTTP Жауап| UI
    AdminPanel -->|7. HTTP Жауап| UI
    
    UI -->|8. Нәтиже көрсету| Customer
    UI -->|8. Нәтиже көрсету| Admin
```