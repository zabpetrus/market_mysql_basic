USE BazarDB;

-- SEGUNDO PROCEDIMENTO: CRIAR TABELAS

/*
Procedimento a ser feito somente uma vez: 
Caso as tabelas precisem ser refeitas, dever-se-á usar outra procedure
que será responsável por excluir as tabelas e suas constraints
*/
DELIMITER //

CREATE PROCEDURE sp_CreateTables()
BEGIN

	-- Tabelas
	CREATE TABLE IF NOT EXISTS Clients (
		client_id INT PRIMARY KEY AUTO_INCREMENT,
		client_name VARCHAR(80) NOT NULL,
		client_email VARCHAR(50) NOT NULL,
		client_cpf VARCHAR(30) NOT NULL,
		client_phone_number VARCHAR(30) NOT NULL
	);


	CREATE TABLE IF NOT EXISTS Products (
		product_id INT PRIMARY KEY AUTO_INCREMENT,
		product_name VARCHAR(150) NOT NULL,
		product_sku VARCHAR(50) NOT NULL,
		product_upc VARCHAR(50) NOT NULL,
		product_item_price DECIMAL(18,2) NOT NULL
	);

	CREATE TABLE IF NOT EXISTS Orders (
		order_ID INT PRIMARY KEY AUTO_INCREMENT,
		client_id INT NOT NULL,
		order_def_id INT NOT NULL,
		order_purchase_date DATETIME NOT NULL,
		order_payments_date DATETIME NOT NULL,
		order_ship_city VARCHAR(50) NOT NULL,
		order_ship_state VARCHAR(50) NOT NULL,
		order_ship_postal_code VARCHAR(10) NOT NULL,
		order_ship_country VARCHAR(30) NOT NULL,
		order_currency VARCHAR(10) NOT NULL,
		order_ship_service_level VARCHAR(20) DEFAULT 'Standard' CHECK (order_ship_service_level IN ('Standard', 'Express', 'Priority')),
		order_status_delivery VARCHAR(20) NOT NULL DEFAULT 'Processing' CHECK (order_status_delivery IN ('Processing', 'Shipped', 'Delivered', 'In Transit', 'Returned')),
		FOREIGN KEY (client_id) REFERENCES Clients(client_id) ON DELETE CASCADE ON UPDATE CASCADE
	);

	CREATE TABLE IF NOT EXISTS OrderItems (
		oi_order_ID INT PRIMARY KEY AUTO_INCREMENT,
		order_id INT NOT NULL,
		product_id INT NOT NULL,
		oi_order_item_id INT NOT NULL,
		oi_product_price DECIMAL(18,2) NOT NULL,
		oi_quantity_purchased INT NOT NULL,
		oi_item_status VARCHAR(20) NOT NULL DEFAULT 'Processing' CHECK (oi_item_status IN ('Processing', 'Shipped', 'Delivered', 'In Transit', 'Returned')),
		FOREIGN KEY (order_id) REFERENCES Orders(order_ID) ON DELETE CASCADE ON UPDATE CASCADE,
		FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE ON UPDATE CASCADE
	);

	CREATE TABLE IF NOT EXISTS Purchase_Requests (
		pr_id INT PRIMARY KEY AUTO_INCREMENT,
		product_id INT NOT NULL,
		pr_supply INT NOT NULL,
		pr_quantity INT NOT NULL,
		pr_unit_price DECIMAL(18,2) NOT NULL,
		pr_total_price DECIMAL(18,2) NOT NULL,
		pr_purchase DATETIME NOT NULL,
		pr_backorder BIT DEFAULT 0
	);

	CREATE TABLE IF NOT EXISTS Internal_Storage (
		is_id INT PRIMARY KEY AUTO_INCREMENT,
		product_id INT NOT NULL,
		is_actual_qte INT DEFAULT 0 NOT NULL,
		is_minimal_qte INT DEFAULT 0 NOT NULL,
		FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE ON UPDATE CASCADE
	);

	CREATE TABLE IF NOT EXISTS Suppliers (
		s_id INT PRIMARY KEY AUTO_INCREMENT,
		s_name VARCHAR(50) NOT NULL,
		s_cnpj VARCHAR(30) NOT NULL UNIQUE,
		s_email VARCHAR(50) NOT NULL,
		s_city VARCHAR(50) NOT NULL,
		s_country VARCHAR(30) NOT NULL
	);

END//
DELIMITER ;
