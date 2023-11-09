CREATE DATABASE QUANLYBANHANG;
USE QUANLYBANHANG;

CREATE TABLE CUSTOMERS (
    customer_id VARCHAR(4) NOT NULL PRIMARY KEY ,
    name VARCHAR(100) NOT NULL ,
    email VARCHAR(100) NOT NULL ,
    phone VARCHAR(25) NOT NULL ,
    address VARCHAR(255) NOT NULL
);

CREATE TABLE ORDERS (
    order_id VARCHAR(4) NOT NULL PRIMARY KEY ,
    customer_id VARCHAR(4) NOT NULL ,
    order_date DATE NOT NULL ,
    total_amount DOUBLE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS(customer_id)
);


CREATE TABLE PRODUCTS (
    product_id VARCHAR(4) NOT NULL PRIMARY KEY ,
    name VARCHAR(255) NOT NULL ,
    description TEXT,
    price DOUBLE NOT NULL ,
    status BIT(1) DEFAULT 1 NOT NULL
);

CREATE TABLE ORDERS_DETAILS (
    order_id VARCHAR(4) NOT NULL ,
    product_id VARCHAR(4) NOT NULL ,
    quantity INT(11) NOT NULL ,
    price DOUBLE NOT NULL ,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCTS(product_id)
);



# Bài 2: Thêm dữ liệu
INSERT INTO CUSTOMERS
VALUES ('C001', 'Nguyễn Trung Mạnh', 'manhnt@gmail.com', '984756322', 'Cầu Giấy, Hà Nội'),
       ('C002', 'Hồ Hải Nam', 'namhh@gmail.com', '984875926', 'Ba Vì, Hà Nội'),
       ('C003', 'Tô Ngọc Vũ', 'vutn@gmail.com', '094725784', 'Mộc Châu, Sơn La'),
       ('C004', 'Phạm Ngọc Anh', 'anhpn@gmail.com', '984635365', 'Vinh, Nghệ An'),
       ('C005', 'Trương Minh Cường', 'cuongtm@gmail.com', '989736524', 'Hai Bà Trưng, Hà Nội');

INSERT INTO PRODUCTS (product_id, name, description, price)
VALUES
    ('P001', 'Iphone 13 ProMax', 'Bản 512 GB, xanh lá', 22999999),
    ('P002', 'Dell Vostro V3510', 'Core id5, RAM 8GB', 14999999),
    ('P003', 'Macbook Pro M2', '8CPU 10GPU 8GB 256GB', 28999999),
    ('P004', 'Apple Watch Ultra', 'Titanium Alpine Loop Small', 18999999),
    ('P005', 'Airpods 2 2022', 'Spatial Audio', 4090000);

INSERT INTO ORDERS
VALUES
    ('H001', 'C001', '2023/2/22', 52999997),
    ('H002', 'C001', '2023/3/11', 80999997),
    ('H003', 'C002', '2023/1/22', 54359998),
    ('H004', 'C003', '2023/3/14', 102999995),
    ('H005', 'C003', '2022/3/12', 80999997),
    ('H006', 'C004', '2023/2/1', 110449994),
    ('H007', 'C004', '2023/3/29', 79999996),
    ('H008', 'C005', '2023/2/14', 29999998),
    ('H009', 'C005', '2023/1/10', 28999999),
    ('H010', 'C005', '2023/4/1', 149999994);


INSERT INTO ORDERS_DETAILS
VALUES
    ('H001', 'P002',1, 14999999),
    ('H001', 'P004',2, 18999999),
    ('H002', 'P001',1, 22999999),
    ('H002', 'P003',2, 28999999),
    ('H003', 'P004',2, 18999999),
    ('H003', 'P005',4, 4090000),
    ('H004', 'P002',3, 14999999),
    ('H004', 'P003',2, 28999999),
    ('H005', 'P001',1, 22999999),
    ('H005', 'P003',2, 28999999),
    ('H006', 'P005',5, 4090000),
    ('H006', 'P002',6, 14999999),
    ('H007', 'P004',3, 18999999),
    ('H007', 'P001',1, 22999999),
    ('H008', 'P002',2, 14999999),
    ('H009', 'P003',1, 28999999),
    ('H010', 'P003',2, 28999999),
    ('H010', 'P001',4, 22999999);

# Bài 3: Truy vấn dữ liệu

-- 1. Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers .
SELECT c.name, c.email, c.phone, c.address FROM CUSTOMERS c;

-- 2. Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện thoại và địa chỉ khách hàng).
SELECT
    c.name,
    c.phone,
    c.address
FROM CUSTOMERS c JOIN ORDERS o ON c.customer_id = o.customer_id
WHERE MONTH(o.order_date) = 3 AND YEAR(o.order_date) = 2023;


-- 3. Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm tháng và tổng doanh thu ).
SELECT
    MONTH(o.order_date) AS 'Tháng',
    SUM(o.total_amount) AS 'Tổng doanh thu'
FROM ORDERS o
WHERE YEAR(order_date) = 2023
GROUP BY MONTH(o.order_date) ;

-- 4. Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách hàng, địa chỉ , email và số điên thoại).
SELECT
    c.name,
    c.address,
    c.email,
    c.phone
FROM CUSTOMERS c
         LEFT JOIN ORDERS o ON c.customer_id = o.customer_id
    AND MONTH(O.order_date) = 2 AND YEAR(O.order_date) = 2023
WHERE O.order_id IS NULL;

/* 5. Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã
 sản phẩm, tên sản phẩm và số lượng bán ra).*/

SELECT
    od.product_id,
    p.name AS product_name,
    SUM(od.quantity) AS total_quantity
FROM ORDERS_DETAILS od
         JOIN ORDERS o ON od.order_id = O.order_id
         JOIN PRODUCTS p ON od.product_id = P.product_id
WHERE MONTH(o.order_date) = 3 AND YEAR(O.order_date) = 2023
GROUP BY od.product_id;

/* 6. Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi
  tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu).*/

SELECT
    c.customer_id,
    c.name AS customer_name,
    SUM(o.total_amount) AS 'Tổng chi tiêu'
FROM CUSTOMERS c
         LEFT JOIN ORDERS o ON C.customer_id = o.customer_id AND YEAR(o.order_date) = 2023
GROUP BY c.customer_id
ORDER BY 'Tổng chi tiêu' DESC;

/* 7. Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm
tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm) */

SELECT
    c.name,
    o.total_amount,
    o.order_date,
    SUM(od.quantity) AS 'Tổng số lượng sản phẩm'
FROM CUSTOMERS c JOIN ORDERS o ON c.customer_id = o.customer_id
  JOIN ORDERS_DETAILS od ON o.order_id = od.order_id
GROUP BY od.order_id
HAVING 'Tổng số lượng sản phẩm' >= 5;


# Bài 4: Tạo View, Procedure

/* 1. Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng
tiền và ngày tạo hoá đơn . */

CREATE VIEW vw_cus_order AS
SELECT
    c.name,
    c.phone,
    c.address,
    o.total_amount,
    o.order_date
FROM CUSTOMERS c JOIN ORDERS o ON c.customer_id = o.customer_id;


/* 2.Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng
số đơn đã đặt. */
CREATE VIEW total_orderOfCus AS
SELECT
    c.name,
    c.address,
    c.phone,
    COUNT(o.order_id)
FROM CUSTOMERS c JOIN ORDERS o ON c.customer_id = o.customer_id
GROUP BY o.customer_id;


/* 3. Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã bán ra của mỗi sản phẩm.*/

CREATE VIEW ProductInfo AS
SELECT
    p.name ,
    P.description,
    p.price,
    SUM(od.quantity) AS total_quantity_sold
FROM PRODUCTS p
         JOIN ORDERS_DETAILS od ON p.product_id = od.product_id
GROUP BY p.product_id;

/* 4. Đánh Index cho trường `phone` và `email` của bảng Customer.*/
ALTER TABLE CUSTOMERS
    ADD INDEX idx_phone (phone),
    ADD INDEX idx_email (email);

/* 5. Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.*/

DELIMITER &&
CREATE PROCEDURE CUSTOMERS_INFOR_ONLY(IN c_CUSTOMERS VARCHAR(4))
BEGIN
    SELECT * FROM CUSTOMERS c WHERE c.customer_id = c_CUSTOMERS;
end &&
DELIMITER ;

CALL CUSTOMERS_INFOR_ONLY('C001');

/* 6. Tạo PROCEDURE lấy thông tin của tất cả sản phẩm.*/
DELIMITER &&
CREATE PROCEDURE PRODUCTS_INFOR ()
BEGIN
    SELECT * FROM PRODUCTS;
end &&
DELIMITER ;
