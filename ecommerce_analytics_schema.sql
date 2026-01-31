
USE ecommerce_analytics;
SHOW TABLES;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);


CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL,
    category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
);


CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
    order_status VARCHAR(50) DEFAULT 'PLACED',

    CONSTRAINT fk_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id)
);



CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);


CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_method VARCHAR(50),
    payment_status VARCHAR(50),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_payment_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);


CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_review_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id),

    CONSTRAINT fk_review_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);








INSERT INTO categories (category_name) VALUES
('Electronics'),
('Clothing'),
('Books');

INSERT INTO users (name, email, password) VALUES
('Harsha', 'harsha@gmail.com', 'pass123'),
('Arjun', 'arjun@gmail.com', 'pass123'),
('Sita', 'sita@gmail.com', 'pass123');


INSERT INTO products (product_name, price, stock_quantity, category_id) VALUES
('Mobile Phone', 20000, 50, 1),
('Laptop', 60000, 30, 1),
('T-Shirt', 1000, 100, 2),
('Java Book', 800, 40, 3);


INSERT INTO orders (user_id, total_amount) VALUES
(1, 21000),
(2, 60000),
(1, 800);


INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 20000),
(1, 3, 1, 1000),
(2, 2, 1, 60000),
(3, 4, 1, 800);


INSERT INTO payments (order_id, payment_method, payment_status) VALUES
(1, 'UPI', 'SUCCESS'),
(2, 'CARD', 'SUCCESS'),
(3, 'UPI', 'SUCCESS');


INSERT INTO reviews (user_id, product_id, rating, comment) VALUES
(1, 1, 5, 'Excellent mobile'),
(2, 2, 4, 'Good laptop'),
(3, 4, 5, 'Very helpful book');


SELECT 
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS total_revenue
FROM orders;

SELECT 
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC;

SELECT 
    c.category_name,
    SUM(oi.quantity * oi.price) AS category_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY category_revenue DESC;

SELECT 
    u.name,
    COUNT(o.order_id) AS total_orders
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.name
HAVING COUNT(o.order_id) > 1;

SELECT 
    AVG(total_amount) AS average_order_value
FROM orders;


SELECT 
    u.name,
    SUM(o.total_amount) AS customer_lifetime_value
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.name
ORDER BY customer_lifetime_value DESC;


SELECT 
    p.product_name,
    IFNULL(SUM(oi.quantity), 0) AS total_quantity_sold
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold ASC;

SELECT 
    payment_status,
    COUNT(payment_id) AS count
FROM payments
GROUP BY payment_status;








