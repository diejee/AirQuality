# Name of the repo
REPO=diejee

# Name of the image
IMAGE=AirQuality

# Current branch-commit (example: master-ab01c1z)
CURRENT=`echo $$TRAVIS_BRANCH | cut -d'/' -f 2-`-$$(git rev-parse HEAD | cut -c1-7)

# Colors
GREEN=\033[0;32m
NC=\033[0m

build:
	echo "$(GREEN)--- BUILDING DOCKER API IMAGE ---$(NC)"
	rm -rf node_modules
	docker-compose build -t $(REPO)/$(IMAGE):$(CURRENT) .

push:
	echo "$(GREEN)--- PUSHING API IMAGE TO HUB ---$(NC)"
	docker push $(REPO)/$(IMAGE):$(CURRENT)