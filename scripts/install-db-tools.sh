#! /bin/bash

sudo yum update -y
sudo yum install -y autoconf readline-devel zlib-devel jq
sudo yum install -y gcc jemalloc-devel openssl-devel tcl tcl-devel clang wget
wget https://ftp.postgresql.org/pub/source/v12.5/postgresql-12.5.tar.gz
tar -xzf postgresql-12.5.tar.gz
cd postgresql-12.5
autoconf
./configure
make -j 4 all
sudo make install

export REGION=`aws configure get region`

echo "export DBUSER=\`aws secretsmanager get-secret-value  --secret-id \"/pgsp/dbsecret\" --region $REGION --query 'SecretString' --output text | jq -r '.\"username\"'\`" >> ~/.bashrc
echo "export PORT=\`aws secretsmanager get-secret-value  --secret-id \"/pgsp/dbsecret\" --region $REGION --query 'SecretString' --output text | jq -r '.\"port\"'\`" >> ~/.bashrc
echo "export DB=\`aws secretsmanager get-secret-value  --secret-id \"/pgsp/dbsecret\" --region $REGION --query 'SecretString' --output text | jq -r '.\"dbname\"'\`" >> ~/.bashrc
echo "export HOST=\`aws secretsmanager get-secret-value  --secret-id \"/pgsp/dbsecret\" --region $REGION --query 'SecretString' --output text | jq -r '.\"host\"'\`" >> ~/.bashrc
echo "export DBPASSWORD=\`aws secretsmanager get-secret-value  --secret-id \"/pgsp/dbsecret\" --region $REGION --query 'SecretString' --output text | jq -r '.\"password\"'\`" >> ~/.bashrc

echo "export RPTDBUSER=\`aws secretsmanager get-secret-value  --secret-id \"/pgsp/reportingdbsecret\" --region $REGION --query 'SecretString' --output text | jq -r '.\"username\"'\`" >> ~/.bashrc
echo "export RPTDBPORT=\`aws secretsmanager get-secret-value  --secret-id \"/pgsp/reportingdbsecret\" --region $REGION --query 'SecretString' --output text | jq -r '.\"port\"'\`" >> ~/.bashrc
echo "export RPTDB=\`aws secretsmanager get-secret-value  --secret-id \"/pgsp/reportingdbsecret\" --region $REGION --query 'SecretString' --output text | jq -r '.\"dbname\"'\`" >> ~/.bashrc
echo "export RPTHOST=\`aws secretsmanager get-secret-value  --secret-id \"/pgsp/reportingdbsecret\" --region $REGION --query 'SecretString' --output text | jq -r '.\"host\"'\`" >> ~/.bashrc
echo "export RPTDBPASSWORD=\`aws secretsmanager get-secret-value  --secret-id \"/pgsp/reportingdbsecret\" --region $REGION --query 'SecretString' --output text | jq -r '.\"password\"'\`" >> ~/.bashrc

echo "export PATH=\"$PATH:/usr/local/pgsql/bin\"" >> ~/.bashrc

