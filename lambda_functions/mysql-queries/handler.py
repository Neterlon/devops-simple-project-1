import pymysql
from os import path, environ

# Configuration values 
endpoint = environ.get("db_endpoint")
username = environ.get("db_username")
password = environ.get("db_password")
database_name = environ.get("db_name")
sql_file_path = "petclinic.sql"

# Get sql queries from a .sql file
def get_sql_from_file(filename):
    if path.isfile(filename) is False:
        print("File load error : {}".format(filename))
        return False
    else:
        with open(filename, "r") as sql_file:
            # Split file in list
            ret = sql_file.read().split(';')
            # drop last empty entry
            ret.pop()
            return ret

# Save queries into a variable

# Сonnecting to the database and queries execution
connection = pymysql.connect(host=endpoint, user=username, password=password, database=database_name)
def lambda_handler(event, context):
	request_list = get_sql_from_file(sql_file_path)
	cursor = connection.cursor()
	for query in request_list:
		cursor.execute(query)
		print(query)
	connection.commit()
