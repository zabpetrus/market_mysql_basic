USE BazarDB;


-- Vendo quais produtos estao no estoque
SELECT products.product_id FROM products 
left JOIN internal_storage ON internal_storage.product_id = products.product_id
WHERE internal_storage.is_actual_qte > 0;

-- Atualizando o produto no estoque



UPDATE `bazardb`.`internal_storage` 
SET `is_actual_qte` = 10
WHERE internal_storage.product_id = 1;
