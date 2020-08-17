.PHONY: help
.DEFAULT_GOAL := help
# RUN := $(shell realpath $(shell dirname $(firstword $(MAKEFILE_LIST)))/run.sh)

help:

	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-46s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

	
start: composer-start influxdb-onboarding ## Start InfluxDB, Kafka, Zookeeper, Create topics and generate data to test

stop: composer-stop ## Stop all containers

clear: composer-stop ## Clear all data: containers
	$(RUN) docker-compose rm -f

composer-start: ## Start composer
	$(RUN) docker-compose up -d --build

composer-stop: ## Stop composer
	$(RUN) docker-compose stop

influxdb-onboarding: ## OnBoarding, Install Kafka Template
	$(RUN) docker-compose exec influxdb_v2 ./influxdb-onboarding.sh
