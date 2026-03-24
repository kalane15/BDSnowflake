-- =========================
-- 1. PETS
-- =========================
INSERT INTO dim_customer_pet (customer_pet_type, customer_pet_name, customer_pet_breed)
SELECT DISTINCT
    customer_pet_type,
    customer_pet_name,
    customer_pet_breed
FROM mock_data;

-- =========================
-- 2. CUSTOMERS
-- =========================
INSERT INTO dim_customer (
    customer_first_name,
    customer_last_name,
    customer_age,
    customer_email,
    customer_country,
    customer_postal_code,
    customer_pet_id,
    pet_category
)
SELECT DISTINCT
    m.customer_first_name,
    m.customer_last_name,
    m.customer_age,
    m.customer_email,
    m.customer_country,
    m.customer_postal_code,
    p.customer_pet_id,
    m.pet_category
FROM mock_data m
LEFT JOIN dim_customer_pet p
    ON m.customer_pet_type = p.customer_pet_type
   AND m.customer_pet_name = p.customer_pet_name
   AND m.customer_pet_breed = p.customer_pet_breed;

-- =========================
-- 3. SELLERS
-- =========================
INSERT INTO dim_seller (
    seller_first_name,
    seller_last_name,
    seller_email,
    seller_country,
    seller_postal_code
)
SELECT DISTINCT
    seller_first_name,
    seller_last_name,
    seller_email,
    seller_country,
    seller_postal_code
FROM mock_data;

-- =========================
-- 4. SUPPLIERS
-- =========================
INSERT INTO dim_supplier (
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    supplier_city,
    supplier_country
)
SELECT DISTINCT
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    supplier_city,
    supplier_country
FROM mock_data;

-- =========================
-- 5. PRODUCTS
-- =========================
INSERT INTO dim_product (
    product_supplier_id,
    product_name,
    product_category,
    product_price,
    product_quantity,
    product_weight,
    product_color,
    product_size,
    product_brand,
    product_material,
    product_description,
    product_rating,
    product_reviews,
    product_release_date,
    product_expiry_date
)
SELECT DISTINCT
    s.product_supplier_id,
    m.product_name,
    m.product_category,
    m.product_price,
    m.product_quantity,
    m.product_weight,
    m.product_color,
    m.product_size,
    m.product_brand,
    m.product_material,
    m.product_description,
    m.product_rating,
    m.product_reviews,
    m.product_release_date,
    m.product_expiry_date
FROM mock_data m
LEFT JOIN dim_supplier s
    ON m.supplier_name = s.supplier_name
   AND m.supplier_email = s.supplier_email;

-- =========================
-- 6. STORES
-- =========================
INSERT INTO dim_store (
    store_name,
    store_location,
    store_city,
    store_state,
    store_country,
    store_phone,
    store_email
)
SELECT DISTINCT
    store_name,
    store_location,
    store_city,
    store_state,
    store_country,
    store_phone,
    store_email
FROM mock_data;

CREATE INDEX idx_product_name ON dim_product(product_name);
CREATE INDEX idx_seller_email ON dim_seller(seller_email);
CREATE INDEX idx_customer_email ON dim_customer(customer_email);
CREATE INDEX idx_store_name ON dim_store(store_name);

-- =========================
-- 7. FACT TABLE
-- =========================
INSERT INTO fact_sales (
    sale_product_id,
    sale_seller_id,
    sale_customer_id,
    sale_store_id,
    sale_quantity,
    sale_total_price,
    sale_date
)
SELECT
    p.sale_product_id,
    s.sale_seller_id,
    c.sale_customer_id,
    st.sale_store_id,
    m.sale_quantity,
    m.sale_total_price,
    TO_DATE(m.sale_date, 'MM/DD/YYYY')
FROM mock_data m
JOIN dim_product p
    ON m.product_name = p.product_name
    AND p.product_price = m.product_price
JOIN dim_seller s
    ON m.seller_email = s.seller_email
    AND m.seller_first_name = s.seller_first_name 
    AND m.seller_last_name = s.seller_last_name
JOIN dim_customer c
    ON m.customer_email = c.customer_email
    AND m.customer_first_name = c.customer_first_name
    AND m.customer_last_name = c.customer_last_name
JOIN dim_store st
    ON m.store_name = st.store_name
    AND st.store_email = m.store_email;