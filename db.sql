-- �������� ����� (��� ������ �����������)
CREATE SCHEMA IF NOT EXISTS app;
SET search_path TO app, public;

-- ������� ��� ����� ��������� (��� ������������, ���� � ������� ��� - ������, ��� �������� ��������)
CREATE TABLE IF NOT EXISTS app.partner_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- ������� ��� ���������
CREATE TABLE IF NOT EXISTS app.partners (
    id SERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL,  -- ����� ������� FK �� partner_types.id, �� ��� �������� ������
    name VARCHAR(100) NOT NULL,
    director_fio VARCHAR(100) NOT NULL,
    address VARCHAR(200) NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 0),
    phone VARCHAR(20),
    email VARCHAR(100)
);

-- ������� ��� ����� ���������
CREATE TABLE IF NOT EXISTS app.product_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    coefficient DOUBLE PRECISION NOT NULL  -- ����������� ���� ���������
);

-- ������� ��� ����� ����������
CREATE TABLE IF NOT EXISTS app.material_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    defect_percent DOUBLE PRECISION NOT NULL  -- ������� ����� (��������, 0.1 ��� 10%)
);

-- ������� ��� ���������
CREATE TABLE IF NOT EXISTS app.products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    product_type_id INTEGER NOT NULL,
    min_price_for_partner DECIMAL(10,2) NOT NULL CHECK (min_price_for_partner >= 0),
    stock_quantity INTEGER NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),  -- ���������� �� ������
    param1 DOUBLE PRECISION NOT NULL CHECK (param1 > 0),  -- �������� ��������� 1
    param2 DOUBLE PRECISION NOT NULL CHECK (param2 > 0),  -- �������� ��������� 2
    FOREIGN KEY (product_type_id) REFERENCES app.product_types(id) ON DELETE RESTRICT
);

-- ������� ��� ������
CREATE TABLE IF NOT EXISTS app.applications (
    id SERIAL PRIMARY KEY,
    partner_id INTEGER NOT NULL,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    total_cost DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (total_cost >= 0),
    FOREIGN KEY (partner_id) REFERENCES app.partners(id) ON DELETE CASCADE
);

-- ������� ��� ��������� � ������ (������-��-������)
CREATE TABLE IF NOT EXISTS app.application_products (
    id SERIAL PRIMARY KEY,
    application_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    FOREIGN KEY (application_id) REFERENCES app.applications(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES app.products(id) ON DELETE RESTRICT
);

-- ������� ��� ������������������
CREATE INDEX IF NOT EXISTS idx_partner_id ON app.applications(partner_id);
CREATE INDEX IF NOT EXISTS idx_product_id ON app.application_products(product_id);

-- ���������� ��������� �������

-- ���� ���������
INSERT INTO app.product_types (name, coefficient) VALUES
('���1', 1.2),
('���2', 1.5),
('���3', 0.8);

-- ���� ����������
INSERT INTO app.material_types (name, defect_percent) VALUES
('�������� A', 0.05),  -- 5% �����
('�������� B', 0.10),
('�������� C', 0.02);

-- ��������
INSERT INTO app.partners (type, name, director_fio, address, rating, phone, email) VALUES
('������������', '������� ���', '������ ���� ��������', '������, ��. ������, 10', 4, '+7(495)123-45-67', 'partner1@example.com'),
('��������� ��������', '������� ����', '������� ���� ���������', '�����-���������, ��. �������, 20', 5, '+7(812)765-43-21', 'partner2@example.com'),
('�������', '�������� ��������', '������� ������� ��������', '������������, ��. ��������, 30', 3, '+7(343)987-65-43', 'partner3@example.com');

-- ���������
INSERT INTO app.products (name, product_type_id, min_price_for_partner, stock_quantity, param1, param2) VALUES
('������� Alpha', 1, 100.50, 50, 2.5, 3.0),
('������� Beta', 2, 200.00, 30, 1.8, 4.2),
('������� Gamma', 3, 150.75, 100, 3.1, 2.7),
('������� Delta', 1, 120.00, 20, 2.0, 3.5);
-- ������
INSERT INTO app.applications (partner_id, date, total_cost) VALUES
(1, '2025-09-01', 0),
(2, '2025-09-05', 0),
(3, '2025-09-10', 0);

-- ��������� � �������
INSERT INTO app.application_products (application_id, product_id, quantity) VALUES
(1, 1, 10),  -- ��� ������ 1: 10x Alpha
(1, 2, 5),   -- 5x Beta
(2, 3, 20),  -- ��� ������ 2: 20x Gamma
(3, 4, 15);  -- ��� ������ 3: 15x Delta

-- ���������� total_cost (������������ ��������� ������)
UPDATE app.applications
SET total_cost = (
    SELECT COALESCE(SUM(ap.quantity * p.min_price_for_partner), 0)
    FROM app.application_products ap
    JOIN app.products p ON ap.product_id = p.id
    WHERE ap.application_id = app.applications.id
);

-- �������� ������
SELECT '���� ������ ������� � ��������� ��������� �������.' AS message;