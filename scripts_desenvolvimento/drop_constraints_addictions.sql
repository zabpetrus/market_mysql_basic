USE bazardb;


ALTER TABLE orders DROP CONSTRAINT orders_ibfk_1;

ALTER TABLE products DROP CONSTRAINT internal_storage_ibfk_1;
    
ALTER TABLE orders DROP CONSTRAINT orderitems_ibfk_1;
    
ALTER TABLE products DROP CONSTRAINT orderitems_ibfk_2;

