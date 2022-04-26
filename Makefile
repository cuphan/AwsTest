S3_BUCKET = lambda-function-billidentity
GIT_SHA := $(shell git rev-parse --short HEAD)
COMPOSE_RUN = docker-compose run --rm dotnet
ZIP_COMPOSE_RUN = docker-compose run --rm zip

.PHONY: shell
shell:
	$(COMPOSE_RUN) sh

.PHONY: restore
restore:
	$(COMPOSE_RUN) dotnet restore

.PHONY: clean
clean: restore
	$(COMPOSE_RUN) dotnet clean	

.PHONY: build
build: clean
	$(COMPOSE_RUN) dotnet build -c Release

.PHONY: test
test: build
	$(COMPOSE_RUN) dotnet test AwsTest.Tests/AwsTest.Tests.csproj

.PHONY: publish
publish: build
	$(COMPOSE_RUN) dotnet publish -o Publish

.PHONY: zip
zip: publish
	$(ZIP_COMPOSE_RUN) zip -r $(GIT_SHA).zip Publish/

.PHONY: upload
upload: zip
	docker-compose run --rm aws --version
	docker-compose run --rm aws --profile bidenergy s3 ls
	#docker-compose run --rm aws s3 cp $(GIT_SHA).zip s3://$(S3_BUCKET)/