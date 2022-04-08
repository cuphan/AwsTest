S3_BUCKET = lambda-function-billidentity
GIT_SHA := $(shell git rev-parse --short HEAD)

restore:
	dotnet restore

clean:
	dotnet clean

build:
	dotnet build -c Release

test: 
	dotnet test AwsTest.Tests/AwsTest.Tests.csproj

publish:
	dotnet publish -o Publish
	zip -r $(GIT_SHA).zip Publish/

upload:
	aws s3 cp $(GIT_SHA).zip s3://$(S3_BUCKET)/

cleanup:
	rm $(GIT_SHA).zip