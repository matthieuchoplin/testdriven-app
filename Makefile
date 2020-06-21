.DEFAULT_GOAL := help # Sets default action to be help

define PRINT_HELP_PYSCRIPT # start of Python section
import re, sys

output = []
# Loop through the lines in this file
for line in sys.stdin:
    # if the line has a command and a comment start with
    #   two pound signs, add it to the output
    match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
    if match:
        target, help = match.groups()
        output.append("%-20s %s" % (target, help))
# Sort the output in alphanumeric order
output.sort()
# Print the help result
print('\n'.join(output))
endef
export PRINT_HELP_PYSCRIPT # End of python section

help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

include .env
export $(shell sed 's/=.*//' .env)

build-server:  ## Build server
	docker-compose build users

migrate-init:
	docker-compose exec users python manage.py db init

migrate:
	docker-compose exec users python manage.py db migrate
	docker-compose exec users python manage.py db upgrade

build-client:  ## Build client
	docker-compose build client

up-server:  ## Bring users service containers up
	docker-compose up -d users

up-client:  ## Bring client container up
	docker-compose up -d client

down:  ## down
	docker-compose down

run:  ## run
	docker-compose up

run-d:  ## run in detached mode
	docker-compose up -d users
	docker-compose up -d client

run-client:  ## run client
	docker-compose up client

test-client:  ## test client
	docker-compose exec -T client npm test a --watchAll=false

recreatedb:  up-server  ## recreatedb
	docker-compose exec users python manage.py recreate_db

test-server: up-server  ## test
	docker-compose exec -T users python manage.py test

test-coverage: ## Run the tests with coverage
	docker-compose exec users python manage.py cov

shell:  ## shell
	docker-compose exec users flask shell

localdb:  ## localdb
	docker-compose exec users-db psql -U postgres

localdb-dev:  ## localdb-dev
	docker-compose exec users-db psql -U postgres -d users_dev

seed_db:  ## seed_db
	docker-compose exec users python manage.py seed_db

black: ## black
	black -t py37 services/users/project

black-test:  ## black-test
	black --check -t py37 services/users/project

mypy: ## mypy
	mypy $$(find services/users/project/ -name '*.py')

precommit: ## precommit
	black mypy test

