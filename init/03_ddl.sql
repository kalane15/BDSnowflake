-- =========================
-- DIMENSION TABLES
-- =========================

CREATE TABLE dim_customer_pet (
    customer_pet_id SERIAL PRIMARY KEY,
    customer_pet_type VARCHAR(50),
    customer_pet_name VARCHAR(100),
    customer_pet_breed VARCHAR(100)
);

CREATE TABLE dim_customer (
    sale_customer_id SERIAL PRIMARY KEY,
    customer_first_name VARCHAR(100),
    customer_last_name VARCHAR(100),
    customer_age INT,
    customer_email VARCHAR(200),
    customer_country VARCHAR(100),
    customer_postal_code VARCHAR(20),
    customer_pet_id INT,
    pet_category VARCHAR(100),
    FOREIGN KEY (customer_pet_id) REFERENCES dim_customer_pet(customer_pet_id)
);

CREATE TABLE dim_seller (
    sale_seller_id SERIAL PRIMARY KEY,
    seller_first_name VARCHAR(100),
    seller_last_name VARCHAR(100),
    seller_email VARCHAR(200),
    seller_country VARCHAR(100),
    seller_postal_code VARCHAR(20)
);

CREATE TABLE dim_supplier (
    product_supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(200),
    supplier_contact VARCHAR(200),
    supplier_email VARCHAR(200),
    supplier_phone VARCHAR(50),
    supplier_address VARCHAR(200),
    supplier_city VARCHAR(100),
    supplier_country VARCHAR(100)
);

CREATE TABLE dim_product (
    sale_product_id SERIAL PRIMARY KEY,
    product_supplier_id INT,
    product_name VARCHAR(200),
    product_category VARCHAR(100),
    product_price NUMERIC(10,2),
    product_quantity INT,
    product_weight NUMERIC(10,2),
    product_color VARCHAR(50),
    product_size VARCHAR(50),
    product_brand VARCHAR(100),
    product_material VARCHAR(100),
    product_description TEXT,
    product_rating NUMERIC(3,1),
    product_reviews INT,
    product_release_date VARCHAR(20),
    product_expiry_date VARCHAR(20),
    FOREIGN KEY (product_supplier_id) REFERENCES dim_supplier(product_supplier_id)
);

CREATE TABLE dim_store (
    sale_store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(200),
    store_location VARCHAR(200),
    store_city VARCHAR(100),
    store_state VARCHAR(100),
    store_country VARCHAR(100),
    store_phone VARCHAR(50),
    store_email VARCHAR(200)
);

-- =========================
-- FACT TABLE
-- =========================

CREATE TABLE fact_sales (
    id SERIAL PRIMARY KEY,
    sale_product_id SERIAL,
    sale_seller_id SERIAL,
    sale_customer_id SERIAL,
    sale_store_id SERIAL,
    sale_quantity INT,
    sale_total_price NUMERIC(10,2),
    sale_date DATE,
    FOREIGN KEY (sale_product_id) REFERENCES dim_product(sale_product_id),
    FOREIGN KEY (sale_seller_id) REFERENCES dim_seller(sale_seller_id),
    FOREIGN KEY (sale_customer_id) REFERENCES dim_customer(sale_customer_id),
    FOREIGN KEY (sale_store_id) REFERENCES dim_store(sale_store_id)
);