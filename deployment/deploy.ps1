# A simple script used for deployment on a Windows machine

Compress-Archive -Path ../project/*, ../sql_queries/* -DestinationPath project.zip
terraform init
terraform apply -auto-approve