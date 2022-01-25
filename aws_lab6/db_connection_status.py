#!/usr/bin/python3
# -*- coding: utf-8 -*-

# import the psycopg2 database adapter for PostgreSQL
from psycopg2 import connect

# import Python's JSON library to format JSON strings
import json

# instantiate a cursor object from the connection
try:

# declare a new PostgreSQL connection object
    conn = connect (
        dbname = "some_database",
        user = "objectrocket",
        host = "localhost",
        password = "mypass"
        )

# return a dict object of the connection object's DSN parameters
    dsm_param = conn.get_dsn_parameters()

# print the JSON response from the get_dsn_parameters() method call
    print ("\nget_dsn_parameters():", json.dumps(dsm_param, indent=4))

# print the get_dsn_parameters() attributes
    print ("connection dsn():", conn.dsn)
    print ("dbname:", dsm_param["dbname"], "\n")

    print ("DSN:", conn.dsn)

except Exception as err:
    print ("\npsycopg2 connection error:", err)
