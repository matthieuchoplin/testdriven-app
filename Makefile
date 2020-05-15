build:
	docker-compose up -d --build

up:
	docker-compose up -d

down:
	docker-compose down

run:
	docker-compose up

recreatedb:
	docker-compose exec users python manage.py recreate_db

test:
	docker-compose exec users python manage.py test

shell:
	docker-compose exec users flask shell

localdb:
	docker-compose exec users-db psql -U postgres

seed_db:
	docker-compose exec users python manage.py seed_db

black:
	black -t py37 services/users/project

black-test:
	black --check -t py37 services/users/project

mypy:
	mypy $$(find services/users/project/ -name '*.py')

precommit: black mypy test
