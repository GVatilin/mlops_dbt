CSV_PATH ?= ../mlops_clickhouse/data/train.csv
DBT = docker compose run --rm dbt

.PHONY: run load deps build test docs serve lint down

run:
	docker compose up -d --wait clickhouse
	docker compose build dbt

load:
	@test -s "$(CSV_PATH)"
	docker compose exec -T clickhouse clickhouse-client --query 'TRUNCATE TABLE transactions_db.transactions'
	docker compose exec -T clickhouse clickhouse-client --query 'INSERT INTO transactions_db.transactions FORMAT CSVWithNames' < "$(CSV_PATH)"

deps:
	$(DBT) deps

build:
	$(DBT) build

test:
	$(DBT) test

docs:
	$(DBT) docs generate --static

serve:
	docker compose run --rm --service-ports dbt docs serve --host 0.0.0.0 --port 8080

lint:
	docker compose run --rm --entrypoint sqlfluff dbt lint models macros tests

down:
	docker compose down
