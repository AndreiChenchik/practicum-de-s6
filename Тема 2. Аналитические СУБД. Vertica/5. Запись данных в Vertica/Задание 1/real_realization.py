from datetime import datetime
import os

import vertica_python

conn_info = {
    "host": os.environ["VERTICA_HOST"],
    "port": os.environ["VERTICA_PORT"],
    "user": os.environ["VERTICA_USER"],
    "password": os.environ["VERTICA_PASSWORD"],
    "database": "dwh",
    "autocommit": True,
}

N = 10000

with vertica_python.connect(**conn_info) as conn:
    curs = conn.cursor()
    time = datetime.now()
    for i in range(N):
        curs.execute(f"INSERT INTO BAD_IDEA" f" VALUES ({i}, 'asds');")

    conn.commit()
