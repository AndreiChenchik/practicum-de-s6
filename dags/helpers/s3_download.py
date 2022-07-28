import os
from airflow.providers.amazon.aws.hooks.s3 import S3Hook


def download_file(
    *,
    key: str,
    connection_id: str = "de_ycloud_s3",
    bucket_name: str = "sprint6",
    local_path: str = "/data/"
):
    s3_hook = S3Hook(connection_id)

    file = s3_hook.download_file(
        key=key, bucket_name=bucket_name, local_path=local_path
    )

    os.rename(src=file, dst=local_path + key)


if __name__ == "__main__":
    download_file(key="groups.csv")
