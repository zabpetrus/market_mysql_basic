# Market mysql basic 

Projeto de banco de dados básico utilizando o mysql
Convém ressaltar que ainda está em construção. 


>

> **ATENÇÃO!**   Este projeto é somente para referência! Como ainda está em construção, não deve ser copiado, pois devem haver muitos problemas que posteriormente serão corrigidos... Além de ser um trabalho que ainda está sendo avaliado!



A seguir, serão detalhados alguns aspectos do projeto:

## Pastas

**launchers** - contém um script python que popula a tabela carga: script básico ainda não testado e sem validação

**scripts_desenvolvimento** - contém scripts sql para serem usados no ambiente de desenvolvimento. As procedures contém instruções de criação e remoção de tabelas e procedures, para auxiliar quem está modelando a estrutura do banco de dados.

**scripts_producao** - contém scripts sql para serem usados na produção. Em construção ainda


## Tabelas

A seguir, estão as estruturas iniciais das tabelas que serão usadas no projeto:

~~~SQL
-- Tabela Clientes (estrutura inicial)

	CREATE TABLE IF NOT EXISTS Clients (
		client_id INT PRIMARY KEY AUTO_INCREMENT,
		client_name VARCHAR(80) NOT NULL,
		client_email VARCHAR(50) NOT NULL,
		client_cpf VARCHAR(30) NOT NULL,
		client_phone_number VARCHAR(30) NOT NULL
	);
~~~
~~~SQL
    -- Tabela Products (estrutura inicial)

	CREATE TABLE IF NOT EXISTS Products (
		product_id INT PRIMARY KEY AUTO_INCREMENT,
		product_name VARCHAR(150) NOT NULL,
		product_sku VARCHAR(50) NOT NULL,
		product_upc VARCHAR(50) NOT NULL,
		product_item_price DECIMAL(18,2) NOT NULL
	);
~~~
~~~SQL
    -- Tabela Orders (estrutura inicial)

	CREATE TABLE IF NOT EXISTS Orders (
		order_ID INT PRIMARY KEY AUTO_INCREMENT,
		client_id INT NOT NULL,
		order_def_id INT NOT NULL,
		order_purchase_date DATETIME NOT NULL,
		order_payments_date DATETIME NOT NULL,
		order_ship_city VARCHAR(50) NOT NULL,
		order_ship_state VARCHAR(50) NOT NULL,
		order_ship_postal_code VARCHAR(10) NOT NULL,
		order_ship_address_1 VARCHAR(100) NOT NULL,
		order_ship_address_2 VARCHAR(100) NOT NULL,
		order_ship_address_3 VARCHAR(100) NOT NULL,
		order_ship_country VARCHAR(30) NOT NULL,
		order_currency VARCHAR(10) NOT NULL,
        order_ship_service_level VARCHAR(20) DEFAULT 'Standard Shipping' CHECK (order_ship_service_level IN ('Standard Shipping', 'Express Shipping', 'Priority Shipping')),
		order_status_delivery VARCHAR(20) NOT NULL DEFAULT 'Processing' CHECK (order_status_delivery IN ('Processing', 'Shipped', 'Delivered', 'In Transit', 'Returned')),
		FOREIGN KEY (client_id) REFERENCES Clients(client_id) ON DELETE CASCADE ON UPDATE CASCADE
	);

~~~
~~~SQL
    -- Tabela OrderItems (estrutura inicial)

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
~~~
~~~SQL
    -- Tabela Purchase_Requests (estrutura inicial)

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
~~~
~~~SQL
    -- Tabela Internal_Storage (estrutura inicial)
	CREATE TABLE IF NOT EXISTS Internal_Storage (
		is_id INT PRIMARY KEY AUTO_INCREMENT,
		product_id INT NOT NULL,
		is_actual_qte INT DEFAULT 0 NOT NULL,
		is_minimal_qte INT DEFAULT 0 NOT NULL,
		FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE ON UPDATE CASCADE
	);
~~~
~~~SQL
-- Tabela Suppliers (estrutura inicial)
	CREATE TABLE IF NOT EXISTS Suppliers (
		s_id INT PRIMARY KEY AUTO_INCREMENT,
		s_name VARCHAR(50) NOT NULL,
		s_cnpj VARCHAR(30) NOT NULL UNIQUE,
		s_email VARCHAR(50) NOT NULL,
		s_city VARCHAR(50) NOT NULL,
		s_country VARCHAR(30) NOT NULL
	);
~~~



## Etiquetas

Etiquetas para ficar chique: [shields.io](https://shields.io/)

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)
[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/)
[![AGPL License](https://img.shields.io/badge/license-AGPL-blue.svg)](http://www.gnu.org/licenses/agpl-3.0)
