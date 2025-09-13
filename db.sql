-- Создание схемы (для лучшей организации)
CREATE SCHEMA IF NOT EXISTS app;
SET search_path TO app, public;

-- Таблица для типов партнеров (для нормализации, хотя в задании тип - строка, для гибкости создадим)
CREATE TABLE IF NOT EXISTS app.partner_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- Таблица для партнеров
CREATE TABLE IF NOT EXISTS app.partners (
    id SERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL,  -- Можно сделать FK на partner_types.id, но для простоты строка
    name VARCHAR(100) NOT NULL,
    director_fio VARCHAR(100) NOT NULL,
    address VARCHAR(200) NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 0),
    phone VARCHAR(20),
    email VARCHAR(100)
);

-- Таблица для типов продукции
CREATE TABLE IF NOT EXISTS app.product_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    coefficient DOUBLE PRECISION NOT NULL  -- Коэффициент типа продукции
);

-- Таблица для типов материалов
CREATE TABLE IF NOT EXISTS app.material_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    defect_percent DOUBLE PRECISION NOT NULL  -- Процент брака (например, 0.1 для 10%)
);

-- Таблица для продукции
CREATE TABLE IF NOT EXISTS app.products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    product_type_id INTEGER NOT NULL,
    min_price_for_partner DECIMAL(10,2) NOT NULL CHECK (min_price_for_partner >= 0),
    stock_quantity INTEGER NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),  -- Количество на складе
    param1 DOUBLE PRECISION NOT NULL CHECK (param1 > 0),  -- Параметр продукции 1
    param2 DOUBLE PRECISION NOT NULL CHECK (param2 > 0),  -- Параметр продукции 2
    FOREIGN KEY (product_type_id) REFERENCES app.product_types(id) ON DELETE RESTRICT
);

-- Таблица для заявок
CREATE TABLE IF NOT EXISTS app.applications (
    id SERIAL PRIMARY KEY,
    partner_id INTEGER NOT NULL,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    total_cost DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (total_cost >= 0),
    FOREIGN KEY (partner_id) REFERENCES app.partners(id) ON DELETE CASCADE
);

-- Таблица для продукции в заявке (многие-ко-многим)
CREATE TABLE IF NOT EXISTS app.application_products (
    id SERIAL PRIMARY KEY,
    application_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (application_id) REFERENCES app.applications(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES app.products(id) ON DELETE RESTRICT
);

-- Индексы для производительности
CREATE INDEX IF NOT EXISTS idx_partner_id ON app.applications(partner_id);
CREATE INDEX IF NOT EXISTS idx_product_id ON app.application_products(product_id);

-- Заполнение тестовыми данными

-- Типы продукции
INSERT INTO app.product_types (name, coefficient) VALUES
('Тип1', 1.2),
('Тип2', 1.5),
('Тип3', 0.8);

-- Типы материалов
INSERT INTO app.material_types (name, defect_percent) VALUES
('Материал A', 0.05),  -- 5% брака
('Материал B', 0.10),
('Материал C', 0.02);

-- Партнеры
INSERT INTO app.partners (type, name, director_fio, address, rating, phone, email) VALUES
('Дистрибьютор', 'Партнер ООО', 'Иванов Иван Иванович', 'Москва, ул. Ленина, 10', 4, '+7(495)123-45-67', 'partner1@example.com'),
('Розничный продавец', 'Магазин Сеть', 'Петрова Анна Сергеевна', 'Санкт-Петербург, пр. Невский, 20', 5, '+7(812)765-43-21', 'partner2@example.com'),
('Оптовик', 'Торговая Компания', 'Сидоров Алексей Петрович', 'Екатеринбург, ул. Малышева, 30', 3, '+7(343)987-65-43', 'partner3@example.com');

-- Продукция
INSERT INTO app.products (name, product_type_id, min_price_for_partner, stock_quantity, param1, param2) VALUES
('Продукт Alpha', 1, 100.50, 50, 2.5, 3.0),
('Продукт Beta', 2, 200.00, 30, 1.8, 4.2),
('Продукт Gamma', 3, 150.75, 100, 3.1, 2.7),
('Продукт Delta', 1, 120.00, 20, 2.0, 3.5);
-- Заявки
INSERT INTO app.applications (partner_id, date, total_cost) VALUES
(1, '2025-09-01', 0),
(2, '2025-09-05', 0),
(3, '2025-09-10', 0);

-- Продукция в заявках
INSERT INTO app.application_products (application_id, product_id, quantity) VALUES
(1, 1, 10),  -- Для заявки 1: 10x Alpha
(1, 2, 5),   -- 5x Beta
(2, 3, 20),  -- Для заявки 2: 20x Gamma
(3, 4, 15);  -- Для заявки 3: 15x Delta

-- Обновление total_cost (рассчитываем стоимость заявки)
UPDATE app.applications
SET total_cost = (
    SELECT COALESCE(SUM(ap.quantity * p.min_price_for_partner), 0)
    FROM app.application_products ap
    JOIN app.products p ON ap.product_id = p.id
    WHERE ap.application_id = app.applications.id
);

-- Проверка данных
SELECT 'База данных создана и заполнена тестовыми данными.' AS message;