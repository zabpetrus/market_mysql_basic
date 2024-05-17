USE BazarDB;

DELIMITER //
CREATE PROCEDURE sp_CreateForeignKeys()
BEGIN
	
	/*
    CRIANDO CHAVES ESTRANGEIRAS
    */    
    SELECT COUNT(*)
	INTO @constraint_count_1
	FROM information_schema.TABLE_CONSTRAINTS 
	WHERE TABLE_SCHEMA = 'BazarDB' 
	AND TABLE_NAME = 'Orders' 
	AND CONSTRAINT_NAME = 'FK_OR_CLI';
    IF @constraint_count_1 = 0 THEN
			ALTER TABLE Orders ADD CONSTRAINT FK_OR_CLI FOREIGN KEY (client_id) REFERENCES Clients(client_id) ON DELETE CASCADE ON UPDATE CASCADE;
	END IF;
    
    SELECT COUNT(*)
	INTO @constraint_count_2
	FROM information_schema.TABLE_CONSTRAINTS 
	WHERE TABLE_SCHEMA = 'BazarDB' 
	AND TABLE_NAME = 'Internal_Storage' 
	AND CONSTRAINT_NAME = 'FK_IS_PROD';
    IF @constraint_count_2 = 0 THEN
    	ALTER TABLE Internal_Storage ADD CONSTRAINT FK_IS_PROD FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE ON UPDATE CASCADE;
    END IF;
    
	SELECT COUNT(*)
	INTO @constraint_count_3
	FROM information_schema.TABLE_CONSTRAINTS 
	WHERE TABLE_SCHEMA = 'BazarDB' 
	AND TABLE_NAME = 'OrderItems' 
	AND CONSTRAINT_NAME = 'FK_OI_ORD';
    IF @constraint_count_3 = 0 THEN    
		ALTER TABLE OrderItems ADD CONSTRAINT FK_OI_ORD FOREIGN KEY (order_id) REFERENCES Orders(order_ID) ON DELETE CASCADE ON UPDATE CASCADE;
	END IF;
    
    SELECT COUNT(*)
	INTO @constraint_count_4
	FROM information_schema.TABLE_CONSTRAINTS 
	WHERE TABLE_SCHEMA = 'BazarDB' 
	AND TABLE_NAME = 'OrderItems' 
	AND CONSTRAINT_NAME = 'FK_OI_PROD';
    IF @constraint_count_4 = 0 THEN   
		ALTER TABLE OrderItems ADD CONSTRAINT FK_OI_PROD FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE ON UPDATE CASCADE;
	END IF;
END//
DELIMITER ;

