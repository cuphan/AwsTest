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