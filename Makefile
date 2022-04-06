COMPOSE_RUN = docker-compose run dotnet
AWS_REGION = ap-southeast-2
GIT_SHA := $(shell git rev-parse --short HEAD)

shell: 
	docker-compose run dotnet bash

restore:
	$(COMPOSE_RUN) dotnet restore

clean:
	$(COMPOSE_RUN) dotnet clean

build:
	$(COMPOSE_RUN) dotnet build AwsTest.sln

test: 
	$(COMPOSE_RUN) dotnet test AwsTest.Tests/AwsTest.Tests.csproj

cleanDocker:
	docker-compose down --remove-orphans
	rm -f .env	