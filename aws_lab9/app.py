#!/usr/bin/env python3
from psycopg2 import connect
import os
import json
import time

os.mkdir('/script/state')

def state_to_file():
    try:
        conn = connect (
        dbname = "",
        user = os.environ.get('DATABASE_USER'),
        host = os.environ.get('DATABASE_HOST'),
        password = os.environ.get('DATABASE_PASS')
        )

        dsm_param = conn.get_dsn_parameters()
        info = json.dumps(dsm_param, indent=4)

        with open('state/db_connection_detail', 'w') as f:
            f.write(info)

    except Exception as err:
        print ("\npsycopg2 connection error:", err)

    time.sleep(30)
    state_to_file()

state_to_file()
