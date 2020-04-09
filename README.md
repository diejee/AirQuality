# AirQuality

How to run the backend?

Installeer docker

cd in de backend folder en run:
- docker run --rm -v $(pwd):/app composer install

cd vervolgens in de main folder en build de container(s) met het volgende command:
- docker-compose build

Na het builden kan je de container(s) runnen met dit command:
- docker-compose up -d