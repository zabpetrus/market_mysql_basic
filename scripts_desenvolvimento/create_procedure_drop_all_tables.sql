USE BazarDB;

DELIMITER //
CREATE PROCEDURE sp_DropAllTables()
BEGIN
	DROP TABLE IF EXISTS clients;    
    DROP TABLE IF EXISTS  internal_storage;
    DROP TABLE IF EXISTS orderitems;
    DROP TABLE IF EXISTS orders;
    DROP TABLE IF EXISTS products;
    DROP TABLE IF EXISTS purchase_requests;
    DROP TABLE IF EXISTS suppliers;

END//

DELIMITER ;