CREATE TABLE customers (
    customer_id VARCHAR(255),
    customer_unique_id VARCHAR(255),
    customer_zip_code_prefix VARCHAR(255),
    customer_city VARCHAR(255),
    customer_state VARCHAR(2),
	-- primary key (customer_id, customer_unique_id)
	primary key (customer_id)
);

-- CREATE TABLE geolocation (
--     geolocation_zip_code_prefix VARCHAR(255),
-- 	geolocation_lat float,
-- 	geolocation_lng float,
-- 	geolocation_state VARCHAR(2),
-- 	primary key (geolocation_zip_code_prefix, geolocation_lat, geolocation_lng)
-- );

CREATE TABLE orders (
    order_id VARCHAR(255),
	customer_id VARCHAR(255),
	order_status VARCHAR(255),
	order_purchase_timestamp date,
	order_approved_at date,
	order_delivered_carrier_date date,
	order_delivered_customer_date date,
	order_estimated_delivery_date date,
	primary key (order_id),
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE payments (
	order_id VARCHAR(255),
	payment_sequential int,
	payment_type VARCHAR(255),
	payment_installments int,
	payment_value float,
	primary key (order_id, payment_sequential, payment_type, payment_installments),
	FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE products (
	product_id VARCHAR(255),
	product_category VARCHAR(255),
	product_name_length int,
	product_description_length int,
	product_photos_qty int,
	product_weight_g int,
	product_length_cm int,
	product_height_cm int,
	product_width_cm int,
	primary key (product_id)
);

CREATE TABLE sellers (
	seller_id VARCHAR(255),
	seller_zip_code_prefix VARCHAR(255),
	seller_city VARCHAR(255),
	seller_state VARCHAR(255),
	primary key (seller_id)
);

CREATE TABLE order_items (
    order_id VARCHAR(255),
	order_item_id int,
	product_id VARCHAR(255),
	seller_id VARCHAR(255),
	shipping_limit_date date,
	price float,
	freight_value float,
	primary key (order_id, order_item_id),
	FOREIGN KEY (order_id) REFERENCES orders(order_id),
	FOREIGN KEY (product_id) REFERENCES products(product_id),
	FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
);							