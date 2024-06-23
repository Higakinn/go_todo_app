.PHONY: help build build-local up down logs ps test
.DEFAULT_GOAL := help

DOCKER_TAG := latest

build: ## build docker image to deploy
	docker build -t higakinn/gotodo:${DOCKER_TAG} --target deploy ./

build-local: ## build docker image to local development
	docker compose build --no-cache

up: ## do docker compose up with hot reload
	docker compose up -d

down: ## do docker compose down
	docker compose down

logs: ## tail docker compose logs 
	docker compose logs -f

ps: ## check container statut
	docker compose ps

test: ## execute tests
	docker compose run app bash -c "go test -race -shuffle=on ./..."

help: ## show commands
	@printf "\033[36m%-30s\033[0m %-50s %s\n" "[Sub command]" "[Description]" "[Example]"
	@grep -E '^[/a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | perl -pe 's%^([/a-zA-Z_-]+):.*?(##)%$$1 $$2%' | awk -F " *?## *?" '{printf "\033[36m%-30s\033[0m %-50s %s\n", $$1, $$2, $$3}'

