#COMPOSE_RUN = docker-compose run dotnet
#AWS_REGION  = ap-southeast-2
#GIT_SHA := $(shell git rev-parse --short HEAD)

#shell: 
#	docker-compose run dotnet bash

restore:
	dotnet restore

clean:
	dotnet clean

build:
	dotnet build AwsTest.sln

test: 
	dotnet test AwsTest.Tests/AwsTest.Tests.csproj

#cleanDocker:
#	docker-compose down --remove-orphans
#	rm -f .env	