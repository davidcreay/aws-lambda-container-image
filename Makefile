TAG:=aws-lambda-container-image
AWS_REGION:=
AWS_ACCOUNT_ID:=

build:
	@docker build -t $(TAG) .

run:
	@docker run -p 9000:8080 $(TAG)

tag: check_env
	@docker tag  $(TAG):latest $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(TAG):latest

push: check_env
	@docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(TAG):latest

test:
	@curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{ "key": "value" }'

ecr_login: check_env
	@aws ecr get-login-password \
	  --region $(AWS_REGION) | \
	  docker login \
	    --username AWS \
	    --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com

create_repo:
	@aws ecr create-repository \
	  --repository-name $(TAG) \
	  --image-scanning-configuration scanOnPush=true \
	  --image-tag-mutability MUTABLE

check_env: check_aws_region check_aws_account_id

check_aws_region:
ifndef AWS_REGION
	$(eval AWS_REGION := $(shell bash -c 'read -e -p "AWS_REGION: " var; echo $$var'))
endif

check_aws_account_id:
ifndef AWS_ACCOUNT_ID
	$(eval AWS_ACCOUNT_ID := $(shell bash -c 'read -e -p "AWS_ACCOUNT_ID: " var; echo $$var'))
endif
