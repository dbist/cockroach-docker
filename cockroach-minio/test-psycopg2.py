#!/usr/bin/python3

import psycopg2
import psycopg2.errorcodes
import time
import logging
import random


def get_chrg_id(conn):
    with conn.cursor() as cur:
        cur.execute("SELECT chrg_id FROM chrg_cd LIMIT 1")
        logging.debug("print_balances(): status message: {}".format(cur.statusmessage))
        rows = cur.fetchall()
        conn.commit()
        print("chrg_id {}".format(time.asctime()))
        for row in rows:
            print([str(cell) for cell in row])

def main():

    dsn = 'postgresql://root@localhost:26257/customer?sslmode=disable'
    conn = psycopg2.connect(dsn)

    try:
        get_chrg_id(conn)
    except ValueError as ve:
        logging.debug("failed: {}".format(ve))
        pass

    # Close communication with the database.
    conn.close()

if __name__ == '__main__':
    main()