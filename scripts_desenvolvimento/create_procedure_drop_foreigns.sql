USE BazarDB;

/*
Procedimento de exclusão de todas chaves estrangeiras
*/

DELIMITER  //
CREATE PROCEDURE sp_DropForeignKeys()
BEGIN

	DECLARE ebba VARCHAR(150);
    DECLARE done boolean DEFAULT FALSE;

	DECLARE abba CURSOR FOR
    SELECT concat('ALTER TABLE `', TABLE_NAME, '` DROP FOREIGN KEY `', CONSTRAINT_NAME, '`;') 
	FROM information_schema.key_column_usage 
	WHERE CONSTRAINT_SCHEMA = 'BazarDB' 
	AND referenced_table_name IS NOT NULL;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN abba;
    
     read_loop: LOOP
        FETCH abba INTO ebba;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SET @foo := ebba;
        PREPARE stmt FROM @foo;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
	  END LOOP read_loop;    
    
    CLOSE abba;
END //

DELIMITER ;

