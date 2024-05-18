USE BazarDB;
/*
PROCEDIMENTO PARA O BANCO DE DADOS (SCHEMA) BAZARDB!
OBSERVAR OS INSERTS!!!
*/

DELIMITER //
CREATE PROCEDURE PopularTabelas()
BEGIN


-- Populando Clients

INSERT INTO `bazardb`.`clients`
(`client_name`,`client_email`,`client_cpf`,`client_phone_number`)
SELECT DISTINCT carga.buyer_name, carga.buyer_email, carga.cpf, carga.buyer_phone_number from carga
LEFT JOIN clients ON client_cpf = carga.cpf
WHERE NOT EXISTS (
	SELECT 1 FROM clients WHERE clients.client_cpf = carga.upc
);

-- Populando products

INSERT INTO `bazardb`.`products`
(`product_name`,
`product_sku`,
`product_upc`,
`product_item_price`)
SELECT DISTINCT carga.product_name, carga.sku, carga.upc, carga.item_price FROM carga 
LEFT JOIN products ON products.product_upc = carga.upc 
WHERE NOT EXISTS (
	SELECT 1 FROM products WHERE products.product_upc = carga.upc
 );

-- Populando orders

INSERT INTO `bazardb`.`orders`
(`order_ID`,
`client_id`,
`order_def_id`,
`order_purchase_date`,
`order_payments_date`,
`order_ship_city`,
`order_ship_state`,
`order_ship_postal_code`,
`order_ship_address_1`,
`order_ship_address_2`,
`order_ship_address_3`,
`order_ship_country`,
`order_currency`,
`order_ship_service_level`
)
SELECT DISTINCT
  carga.order_id,          -- order_ID
  clients.client_id,       -- client_id
  carga.order_id,          -- order_def_id
  carga.purchase_date,     -- order_purchase_date
  carga.payments_date,     -- order_payments_date
  carga.ship_city,         -- order_ship_city
  carga.ship_state,        -- order_ship_state
  carga.ship_postal_code,  -- order_ship_postal_code
  carga.ship_address_1,    -- order_ship_address_1
  carga.ship_address_2,    -- order_ship_address_2
  carga.ship_address_3,    -- order_ship_address_3
  carga.ship_country,      -- order_ship_country
  carga.currency,          -- order_currency
  carga.ship_service_level -- order_ship_service_level 
FROM carga 
LEFT JOIN clients ON clients.client_cpf = carga.cpf
LEFT JOIN orders ON orders.order_def_id = carga.order_id
WHERE NOT EXISTS (
SELECT 1 FROM Orders WHERE orders.order_def_id = carga.order_id
);


-- inserindo orderitems

INSERT INTO `bazardb`.`orderitems`
(
`order_id`,
`product_id`,
`oi_order_item_id`,
`oi_product_price`,
`oi_quantity_purchased`
)
SELECT
orders.order_ID,
products.product_id,
carga.order_item_id,
products.product_item_price,
carga.quantity_purchased
FROM carga
INNER JOIN orders ON orders.order_def_id = carga.order_id
INNER JOIN products ON products.product_upc = carga.upc
LEFT JOIN orderitems ON orderitems.oi_order_ID = orders.order_ID
WHERE NOT EXISTS (
	SELECT 1 FROM orderitems WHERE orderitems.order_id = orders.order_ID AND product_id = products.product_id
)
GROUP BY order_item_id, quantity_purchased, order_id, product_id,  item_price
ORDER BY  quantity_purchased DESC;

-- Populando estoque

INSERT INTO `bazardb`.`internal_storage`
(`product_id`,
`is_minimal_qte`)
SELECT DISTINCT product_id, SUM( orderitems.oi_quantity_purchased ) FROM orderitems 
WHERE NOT EXISTS (SELECT 1 FROM internal_storage WHERE internal_storage.product_id = orderitems.product_id )
GROUP BY product_id;

-- Populando requisicao de pedidos

INSERT INTO `bazardb`.`purchase_requests`
(
`product_id`,
`pr_supply`,
`pr_quantity`,
`pr_unit_price`,
`pr_total_price`,
`pr_purchase`)

SELECT DISTINCT
products.product_id,
SUM( orderitems.oi_quantity_purchased  * 10),
products.product_item_price,
SUM( products.product_item_price * orderitems.oi_quantity_purchased * 10) AS Total,
MIN(suppliers.s_id),
NOW()
FROM products
INNER JOIN orderitems ON orderitems.product_id = products.product_id
INNER JOIN orders ON orders.order_ID = orderitems.order_id
INNER JOIN suppliers ON suppliers.s_country = orders.order_ship_country OR suppliers.s_city = orders.order_ship_city
LEFT JOIN purchase_requests ON purchase_requests.product_id = products.product_id
WHERE NOT EXISTS (
	SELECT 1 FROM purchase_requests WHERE purchase_requests.product_id = products.product_id
)
GROUP BY products.product_id
ORDER BY Total;





-- Inserindo Fornecedores

INSERT INTO `bazardb`.`suppliers`
(`s_id`, `s_name`, `s_cnpj`, `s_email`, `s_city`, `s_country`)
SELECT 1, 'Johnson & Sons', '39.794.144/0001-00', 'johnson@example.com', 'New York', 'USA'
WHERE NOT EXISTS (SELECT 1 FROM suppliers WHERE suppliers.s_cnpj = '39.794.144/0001-00');

INSERT INTO `bazardb`.`suppliers`
(`s_id`, `s_name`, `s_cnpj`, `s_email`, `s_city`, `s_country`)
SELECT 2, 'Martins & Co', '30.597.365/0001-06', 'martins@example.com', 'Los Angeles', 'USA'
WHERE NOT EXISTS (SELECT 1 FROM suppliers WHERE suppliers.s_cnpj = '30.597.365/0001-06');

INSERT INTO `bazardb`.`suppliers`
(`s_id`, `s_name`, `s_cnpj`, `s_email`, `s_city`, `s_country`)
SELECT 3, 'Silva & Cia', '88.446.564/0001-01', 'silvacompany@hotmail.com', 'Sao Paulo', 'Brazil'
WHERE NOT EXISTS (SELECT 1 FROM suppliers WHERE suppliers.s_cnpj = '88.446.564/0001-01');

INSERT INTO `bazardb`.`suppliers`
(`s_id`, `s_name`, `s_cnpj`, `s_email`, `s_city`, `s_country`)
SELECT 4, 'Rodriguez Ltda', '66.926.401/0001-85', 'rodriguez@example.com', 'Rio de Janeiro', 'Brazil'
WHERE NOT EXISTS (SELECT 1 FROM suppliers WHERE suppliers.s_cnpj = '66.926.401/0001-85');

INSERT INTO `bazardb`.`suppliers`
(`s_id`, `s_name`, `s_cnpj`, `s_email`, `s_city`, `s_country`)
SELECT 5, 'Williams Enterprises', '50.719.611/0001-62', 'williams@example.com', 'Chicago', 'USA'
WHERE NOT EXISTS (SELECT 1 FROM suppliers WHERE suppliers.s_cnpj = '50.719.611/0001-62');

INSERT INTO `bazardb`.`suppliers`
(`s_id`, `s_name`, `s_cnpj`, `s_email`, `s_city`, `s_country`)
SELECT 6, 'Oliveira e Filhos', '15.472.366/0001-30', 'oliveira@tabajara.com', 'Brasília', 'Brazil'
WHERE NOT EXISTS (SELECT 1 FROM suppliers WHERE suppliers.s_cnpj = '15.472.366/0001-30');

INSERT INTO `bazardb`.`suppliers`
(`s_id`, `s_name`, `s_cnpj`, `s_email`, `s_city`, `s_country`)
SELECT 7, 'Smith & Partners', '72.848.418/0001-64', 'smith@example.com', 'Miami', 'USA'
WHERE NOT EXISTS (SELECT 1 FROM suppliers WHERE suppliers.s_cnpj = '72.848.418/0001-64');

INSERT INTO `bazardb`.`suppliers`
(`s_id`, `s_name`, `s_cnpj`, `s_email`, `s_city`, `s_country`)
SELECT 8, 'Garcia & Associates', '58.429.300/0001-70', 'garcia@example.com', 'Orlando', 'USA'
WHERE NOT EXISTS (SELECT 1 FROM suppliers WHERE suppliers.s_cnpj = '58.429.300/0001-70');

INSERT INTO `bazardb`.`suppliers`
(`s_id`, `s_name`, `s_cnpj`, `s_email`, `s_city`, `s_country`)
SELECT 9, 'Ferreira Ltda', '74.572.252/0001-21', 'ferreira@example.com', 'Fortaleza', 'Brazil'
WHERE NOT EXISTS (SELECT 1 FROM suppliers WHERE suppliers.s_cnpj = '74.572.252/0001-21');

INSERT INTO `bazardb`.`suppliers`
(`s_id`, `s_name`, `s_cnpj`, `s_email`, `s_city`, `s_country`)
SELECT 10, 'Brown & Co', '06.858.836/0001-08', 'brown@maroon.com', 'San Francisco', 'USA'
WHERE NOT EXISTS (SELECT 1 FROM suppliers WHERE suppliers.s_cnpj = '06.858.836/0001-08');


END//

DELIMITER ;