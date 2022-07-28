FROM sindb/de-sprint-6:latest
RUN sed -i 's/executor = SequentialExecutor/executor = LocalExecutor/' /opt/airflow/airflow.cfg
