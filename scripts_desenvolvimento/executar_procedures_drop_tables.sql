USE BazarDB;

/*
SCRIPT PARA SER RODADO APÓS FAZER MUDANÇAS NAS ESTRUTURAS DO BANCO:
RECONSTRUÇÃO DA TABELA DE CARGA;
EXCLUSÃO DE TODAS AS CHAVES ESTRANGEIRAS (O MYSQL PODE CRIAR NOVAS CONSTRAINTS AUTOMATICAMENTE)
EXCLUSÃO DE TODAS AS TABELAS
*/

-- Criando nova carga. Essa procedure pode ser feita n vezes
-- CALL sp_CreateTableCarga;

CALL sp_DropForeignKeys();

CALL sp_DropAllTables();






