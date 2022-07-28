from datetime import datetime

from airflow.decorators import task, dag
from airflow.operators.empty import EmptyOperator
from airflow.utils.task_group import TaskGroup

from helpers import s3_download as s3
from helpers import csv_test as csv


@dag(
    schedule_interval="@daily",
    start_date=datetime(2022, 7, 1),
    catchup=False,
)
def sprint6():
    start = EmptyOperator(task_id="start")

    with TaskGroup(group_id="staging") as staging:

        @task
        def s3_users():
            s3.download_file(key="users.csv")

        @task
        def s3_groups():
            s3.download_file(key="groups.csv")

        @task
        def s3_dialogs():
            s3.download_file(key="dialogs.csv")

        @task
        def test_csvs():
            csv.test_csvs(
                files=[
                    "/data/users.csv",
                    "/data/groups.csv",
                    "/data/dialogs.csv",
                ]
            )

        users = s3_users()
        groups = s3_groups()
        dialogs = s3_dialogs()
        test = test_csvs()

        [users, groups, dialogs] >> test

    end = EmptyOperator(task_id="end")

    start >> staging >> end


dag = sprint6()


# 3.2.1 Двигайтесь дальше! Ваш код: NSVMjNvvxQ
# 3.2.2 Двигайтесь дальше! Ваш код: gPXvR0F9IW
