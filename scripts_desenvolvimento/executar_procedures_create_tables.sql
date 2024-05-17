USE BazarDB;

/*
SCRIPT PARA SER RODADO PARA INICIAR AS TRANSACOES NO BANCO
*/

-- Criando nova carga. Essa procedure pode ser feita n vezes
CALL sp_CreateTableCarga;

CALL sp_CreateTables();

CALL sp_CreateForeignKeys();








