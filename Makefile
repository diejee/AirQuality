# Colors
GREEN=\033[0;32m
NC=\033[0m



generateVersionTags:
	# Name of docker hub
	export DOCKER_REPO=jeroenvo

	# Name of the image
	export IMAGE=AirQuality

	# Current branch-commit (example: master-ab01c1z)
	export VERSION_TAG=`echo $$TRAVIS_BRANCH | cut -d'/' -f 2-`-$$(git rev-parse HEAD | cut -c1-7)

build:
	echo "$(GREEN)--- BUILDING DOCKER API IMAGE ---$(NC)"
	docker-compose -f docker-compose-ci.yml build

push:
	echo "$(GREEN)--- PUSHING API IMAGE TO HUB ---$(NC)"
	docker-compose -f docker-compose-ci.yml push