import json
from flask import abort
from typing import List, Dict
from google.cloud import bigquery
from google.cloud.bigquery.table import Row
from google.cloud.bigquery.job.query import QueryJob
from google.cloud.bigquery.client import Client

SQL_FILE = 'source_data_filtering.sql'


def read_sql_query(filename: str) -> str:
    return open(filename, 'r').read()


def retrieve_query_results(query_job: QueryJob) -> List[Row]:
    return [row for row in query_job]


def query_bigquery(query_file_location: str, bq_client: Client) -> List[Row]:
    query = read_sql_query(query_file_location)
    query_job = bq_client.query(query)

    return retrieve_query_results(query_job)


def prepare_output(rows: Row) -> List[Dict]:
    return [dict(list(row.items())) for row in rows]


def main(request):
    if request.method == 'GET':
        bq_client = bigquery.Client()
        response = query_bigquery(SQL_FILE, bq_client)
        output_data = json.dumps(prepare_output(response))
        return output_data
    else:
        return abort(405)


