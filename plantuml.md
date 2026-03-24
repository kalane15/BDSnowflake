@startuml
' Указываем тип диаграммы
!define table class

' Настройки стилей
skinparam backgroundColor #FEFEFE
skinparam componentStyle rectangle
skinparam linetype ortho
skinparam class {
    BackgroundColor #E1F5FE
    BorderColor #0288D1
    ArrowColor #0288D1
}

skinparam class {
    BackgroundColor<<dim>> #E8F5E9
    BorderColor<<dim>> #388E3C
}

skinparam class {
    BackgroundColor<<fact>> #FFF3E0
    BorderColor<<fact>> #F57C00
}

skinparam defaultFontSize 12
skinparam classFontSize 14
skinparam stereotypeFontSize 11

' ========== DIMENSION TABLES ==========

class dim_customer <<dim>> {
    + sale_customer_id : INT <<PK>>
    --
    customer_first_name : VARCHAR(100)
    customer_last_name : VARCHAR(100)
    customer_age : INT
    customer_email : VARCHAR(200)
    customer_country : VARCHAR(100)
    customer_postal_code : VARCHAR(20)
    customer_pet_id : INT <<FK>>
    pet_category : VARCHAR(100)
}

class dim_customer_pet <<dim>> {
    + customer_pet_id : INT <<PK>>
    --
    customer_pet_type : VARCHAR(50)
    customer_pet_name : VARCHAR(100)
    customer_pet_breed : VARCHAR(100)
}

class dim_seller <<dim>> {
    + sale_seller_id : INT <<PK>>
    --
    seller_first_name : VARCHAR(100)
    seller_last_name : VARCHAR(100)
    seller_email : VARCHAR(200)
    seller_country : VARCHAR(100)
    seller_postal_code : VARCHAR(20)
}

' ========== FACT TABLE ==========

class fact_sales <<fact>> {
    + id : INT <<PK>>
    --
    sale_product_id : INT <<FK>>
    sale_seller_id : INT <<FK>>
    sale_customer_id : INT <<FK>>
    sale_store_id : INT <<FK>>
    sale_quantity : INT
    sale_total_price : NUMERIC(10,2)
    sale_date : DATE
}

' ========== DIMENSION TABLES (CONTINUED) ==========

class dim_product <<dim>> {
    + sale_product_id : INT <<PK>>
    --
    product_supplier_id : INT <<FK>>
    product_name : VARCHAR(200)
    product_category : VARCHAR(100)
    product_price : NUMERIC(10,2)
    product_quantity : INT
    product_weight : NUMERIC(10,2)
    product_color : VARCHAR(50)
    product_size : VARCHAR(50)
    product_brand : VARCHAR(100)
    product_material : VARCHAR(100)
    product_description : TEXT
    product_rating : NUMERIC(3,1)
    product_reviews : INT
    product_release_date : VARCHAR(20)
    product_expiry_date : VARCHAR(20)
}

class dim_store <<dim>> {
    + sale_store_id : INT <<PK>>
    --
    store_name : VARCHAR(200)
    store_location : VARCHAR(200)
    store_city : VARCHAR(100)
    store_state : VARCHAR(100)
    store_country : VARCHAR(100)
    store_phone : VARCHAR(50)
    store_email : VARCHAR(200)
}

class dim_supplier <<dim>> {
    + product_supplier_id : INT <<PK>>
    --
    supplier_name : VARCHAR(200)
    supplier_contact : VARCHAR(200)
    supplier_email : VARCHAR(200)
    supplier_phone : VARCHAR(50)
    supplier_address : VARCHAR(200)
    supplier_city : VARCHAR(100)
    supplier_country : VARCHAR(100)
}

' ========== RELATIONSHIPS ==========

' Связи измерений с факт-таблицей
fact_sales "*" --> "1" dim_customer : belongs to
fact_sales "*" --> "1" dim_seller : processed by
fact_sales "*" --> "1" dim_product : contains
fact_sales "*" --> "1" dim_store : sold at

' Связи между измерениями
dim_customer "1" --> "0..*" dim_customer_pet : has pet
dim_product "0..*" --> "1" dim_supplier : supplied by

' ========== РАСПОЛОЖЕНИЕ (ФАКТ В ЦЕНТРЕ) ==========

' Размещаем измерения вокруг факт-таблицы
' Верх: dim_customer и dim_customer_pet
dim_customer_pet -[hidden]u- dim_customer
dim_customer -[hidden]u- fact_sales

' Низ: dim_store
fact_sales -[hidden]d- dim_store

' Лево: dim_seller
dim_seller -[hidden]l- fact_sales

' Право: dim_product и dim_supplier
fact_sales -[hidden]r- dim_product
dim_product -[hidden]r- dim_supplier

' ========== КОММЕНТАРИИ ==========

note bottom of dim_customer
  <b>Измерения</b>
  <color:#388E3C>Описательные атрибуты</color>
end note

@enduml