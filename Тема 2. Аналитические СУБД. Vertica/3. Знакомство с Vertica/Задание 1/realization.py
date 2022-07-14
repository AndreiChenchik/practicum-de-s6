import vertica_python

conn_info = {
    "host": "VERTICA_HOST",
    "port": "VERTICA_PORT",
    "user": "VERTICA_USER",
    "password": "VERTICA_PASSWORD",
    "database": "dwh",
    "autocommit": True,
}


def try_select(conn_info=conn_info):
    with vertica_python.connect(**conn_info) as conn:
        cur = conn.cursor()
        cur.execute("Select 1 as a1;")
        res = cur.fetchall()
        return res


# Двигайтесь дальше! Ваш код: cnnp3IVipV
