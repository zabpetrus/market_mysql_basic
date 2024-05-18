import csv
import mysql.connector

"""
*********************************************************************************
    SCRIPT PARA POPULAR CARGA! PARA USAR SOMENTE MUDE OS VALORES NO CONECTOR!
     ADAPTADO PARA TABELA CARGA, CUJA ESTRUTURA ENCONTRA-SE NO ARQUIVO SQL
*********************************************************************************
"""


def mapping_row(linha, columns):
    resultado = (('#'.join(linha)).replace("#", "")).split(';')

    valores = ", ".join([f"'{valor}'" for valor in resultado])

    sql = f"INSERT INTO carga ({','.join(columns)}) VALUES ({valores})"

    return sql


def script_main():
    # MySQL connection parameters: complete with database parameters    
    cnx = mysql.connector.connect(user='root', password='123456', host='localhost', database='meudatabase')
    cursor = cnx.cursor()

    # CSV file path
    csv_file_path = 'file.txt'
    columns = ['order_id',
               'order_item_id',
               'purchase_date',
               'payments_date',
               'buyer_email',
               'buyer_name',
               'cpf',
               'buyer_phone_number',
               'sku',
               'upc',
               'product_name',
               'quantity_purchased',
               'currency',
               'item_price',
               'ship_service_level',
               'ship_address_1',
               'ship_address_2',
               'ship_address_3',
               'ship_city',
               'ship_state',
               'ship_postal_code',
               'ship_country']

    with open(csv_file_path, mode='r') as csvfile:
        reader = csv.reader(csvfile)
        next(reader)  # Skip the header row
        for row in reader:
            cursor.execute(mapping_row(row, columns))

    cnx.commit()
    cursor.close()
    cnx.close()
