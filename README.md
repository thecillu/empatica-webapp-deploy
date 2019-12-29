# Empatica Webapp Deployment

This project uses Terraform to create an AWS CodeBuild project to manage the [Angular WebApp](https://github.com/thecillu/empatica-webapp) deployment.

In details, the Terraform configuration:

1. Create the Bucket which will contains the Angular WebApp. The Bucket is configured in order to host th webapp and have public-read access to its resources. 
The Bucket name is defined in the variable `webapp_bucket` (default `empatica-webapp`)

2. Create the AWS CodeBuild which (when started), download the source code from the [Angular WebApp](https://github.com/thecillu/empatica-webapp), build the WebApp and copy the compiled version in the created S3 bucket

## AWS Credentials 

The Terraform configuration reads the credentials file from the file: 

`$HOME/.aws/credentials`

Make sure to put in this file the credentials `aws_access_key_id` and `aws_secret_access_key` of a valid AWS User.

## AWS Region

The Terraform configuration uses the variable `aws_region` to indentify the target AWS Region.

By Default the deployment Region is `eu-central-1`.

## Create the AWS CodeBuild project 

Clone the project, change dir to subfolder `terraform` and run the command:

`terraform apply`

## Run AWS CodeBuild project 

In order to deploy the WebApp invoking the created CodeBuild project, use the command:

`aws codebuild  start-build --project-name empatica-webapp-build --source-version <BRANCH_OR_TAG> --region eu-central-1`

Where `<BRANCH_OR_TAG>` contains the branch or the tag of the [Angular WebApp](https://github.com/thecillu/empatica-webapp) you want to deploy.

Example - Deploy the master: 
`aws codebuild  start-build --project-name empatica-webapp-build --source-version master --region eu-central-1`

Example - Deploy tag version 0.0.1: 
`aws codebuild  start-build --project-name empatica-webapp-build --source-version 0.0.1 --region eu-central-1`

Please make sure to create the tag in the project [Angular WebApp](https://github.com/thecillu/empatica-webapp) you want to deploy before to start the AWS CodeBuild project with a specific tag version.

## WebApp address

The output of the command will provide the WebApp address:

`website_endpoint = empatica-webapp.s3-website.eu-central-1.amazonaws.com`



