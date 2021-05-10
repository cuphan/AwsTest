def gv

pipeline {
  agent any

  parameters {
    choice(name: 'lambda_status', choices: 'update\nnew', description: 'Status of lambda function')
    string(name: 'lambda_function_name', defaultValue: 'awstest', description: 'your lambda function name')
    string(name: 'lambda_handler', defaultValue: 'AwsTest::AwsTest.Function::FunctionHandler', description: 'your lambda handler name')
    choice(name: 'dotnet_core_version', choices: 'dotnetcore3.1\ndotnetcore2.1', description: 'lambda function version')
    string(name: 'lambda_role', defaultValue: 'arn:aws:iam::179992185777:role/lambda_fullservices_role', description: 'your lambda role')
    string(name: 's3_bucket', defaultValue: 'jenkins-code-deployment', description: 'The lambda S3 Location')
  }

  environment {
    dotnet = '/usr/bin/dotnet'
    //now = sh(returnStdout: true, script: 'date +%Y-%m-%d-%H-%M').trim()
    folder = "lambda/AwsTest/"
  }

  stages {
    stage('Init') {
      steps {
        script {
          gv = load ".jenkins/script.groovy"
        }
      }
    }

    stage('Checkout') {
      steps {
        git branch: 'master', url: 'https://github.com/vietphan-billidentity/AwsTest.git'
      }
    }

    stage('Restore PACKAGES') {
      steps {
        sh "dotnet restore"
      }
    }

    stage('Clean') {
      steps {
        sh 'dotnet clean'
      }
    }

    stage('Build') {
      steps {
        sh 'dotnet build --configuration Release'
      }
    }

    stage('Test') {
      steps {
        sh 'dotnet test AwsTest.Tests/AwsTest.Tests.csproj'
      }
    }

    stage('Publish and zip') {
      steps {
        sh 'dotnet publish -o Publish'
        script {
          def commit_id = gv.commitID()
          sh "zip -r ${commit_id}.zip Publish/"
        }
      }
    }

    stage('Upload to S3 and update code') {
      when {
        expression { params.lambda_status == 'update' }
      }
      steps {
        withAWS(credentials: 'aws-billidentity', region: 'ap-southeast-2') {
          sh "aws s3api put-object --bucket ${params.s3_bucket} --key ${folder}"
          script {
            def commit_id = gv.commitID()
            sh "aws s3 cp ${commit_id}.zip s3://${params.s3_bucket}/${folder}"
            sleep(time: 15, unit: "SECONDS")
            sh "aws lambda update-function-code --function-name ${params.lambda_function_name} --s3-bucket s3://${params.s3_bucket}/${folder}/${commit_id}.zip"
          }
          //sh "aws lambda update-function-code --function-name ${params.lambda_function_name} --zip-file fileb://AwsTest.zip"
        }
      }
    }

    stage('Create new lamba and upload the binary') {
      when {
        expression { params.lambda_status == 'new' }
      }
      steps {
        withAWS(credentials: 'aws-billidentity', region: 'ap-southeast-2') {
          script {
            def commit_id = gv.commitID()
            sh "aws lambda create-function --function-name ${params.lambda_function_name} --runtime ${params.dotnet_core_version} --handler ${params.lambda_handler} --zip-file fileb://${commit_id}.zip --role ${params.lambda_role}"
          }
        }
      }
    }
  }
}