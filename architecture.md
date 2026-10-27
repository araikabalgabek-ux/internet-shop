# Интернет-дүкен ақпараттық жүйесінің үш деңгейлі архитектурасы

```mermaid
graph TD
    classDef actorStyle fill:#f9f,stroke:#333,stroke-width:2px;
    classDef presentation fill:#bbf,stroke:#333,stroke-width:2px;
    classDef logic fill:#f96,stroke:#333,stroke-width:2px;
    classDef access fill:#ff9,stroke:#333,stroke-width:2px;
    classDef database fill:#6c6,stroke:#333,stroke-width:2px;

    subgraph Presentation_Layer [1. Презентация деңгейі]
        Customer[👤 Сатып алушы / Актер]:::actorStyle
        Admin[👮 Әкімші / Актер]:::actorStyle
        UI[💻 Пайдаланушы интерфейсі <br> Веб-сайт, Формалар, Мобильді қосымша]:::presentation
    end

    subgraph Application_Layer [2. Қолданбалы логика деңгейі]
        Auth[🔐 Авторизация модулі <br> Тіркелу және жүйеге кіру]:::logic
        Catalog[🛍️ Тауарлар каталогы <br> Іздеу, сүзгілеу, тауар көру]:::logic
        Cart[🛒 Тапсырыс搬 беру модулі <br> Себетпен жұмыс және төлем]:::logic
        AdminPanel[📊 Басқару модулі <br> Тауар қосу, тапсырыстарды көру]:::logic
        Notify[🔔 Хабарландыру қызметі <br> SMS/Email жіберу]:::logic
    end

    subgraph Data_Layer [3. Деректер деңгейі]
        DAC[🔄 Деректерге қол жеткізу компоненті <br> SQL сұраныстарды қалыптастыру]:::access
        DB[(🗄️ Реляциялық Дерекқор <br> Users, Products, Orders)]:::database
    end

    Customer -->|1. Сайтқа кіреді / Тауар таңдайды| UI
    UI -->|2. Жүйеге кіру сұранысы| Auth
    UI -->|2. Іздеу өрісінен тауар іздейді| Catalog
    UI -->|2. Тапсырысты рәсімдейді| Cart
    
    Admin -->|1. Панельге кіреді / Тауар қосады| UI
    UI -->|2. Басқару сұранысын жолдайды| AdminPanel

    Auth -->|3. Деректерді өңдеуге бағыттайды| DAC
    Catalog -->|3. Сұранысты жолдайды| DAC
    Cart -->|3. Тапсырыс мәліметін жібереді| DAC
    AdminPanel -->|3. Жаңа тауар мәліметін жібереді| DAC
    
    Cart -.->|Хабарлама жіберу сұранысы| Notify
    
    DAC -->|4. Data Query / Деректерді алу| DB
    DB -->|5. Data Response / Жауап қайтару| DAC
    
    DAC -->|6. Нәтижені өңдеуге береді| Auth
    DAC -->|6. Нәтижені өңдеуге береді| Catalog
    DAC -->|6. Нәтижені өңдеуге береді| Cart
    DAC -->|6. Нәтижені өңдеуге береді| AdminPanel
    
    Catalog -->|7. HTTP Response / Тауарлар тізімі| UI
    Cart -->|7. HTTP Response / Тапсырыс мәртебесі| UI
    AdminPanel -->|7. HTTP Response / Жаңартылған тауарлар| UI
    
    UI -->|8. Тауарды / Тапсырыс сәтті өткенін көреді| Customer
    UI -->|8. Тауар сәтті қосылғанын көреді| Admin
```
