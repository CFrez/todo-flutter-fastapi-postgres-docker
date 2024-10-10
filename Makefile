# Make uses /bin/sh by default, but we are using some bash features.  On Ubuntu
# /bin/sh is POSIX compliant, ie it's not bash.  So let's be explicit:
SHELL=/bin/bash

# Autogenerate migrations
.PHONY: migrations
migrations:
	@read -p "Enter a message for the migration: " message; \
	docker-compose run backend alembic revision --autogenerate -m "$$message"

# Run migrations
.PHONY: migrate
migrate:
	docker-compose run backend alembic upgrade head

# Revert/Rollback migrations
.PHONY: downgrade
downgrade:
	docker-compose run backend alembic downgrade -1

# Run backend tests
.PHONY: test-backend
test-backend:
	docker-compose run backend pytest .
