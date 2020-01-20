IMAGE_NAME:= openid-connect-4-identity-assurance

all: build generate

build:
	docker build -t $(IMAGE_NAME) .

generate:
	docker run --rm -v $$(pwd):/opt $(IMAGE_NAME) mmark -2 main.md > openid-connect-4-identity-assurance-1_0.xml
	patch -p0 openid-connect-4-identity-assurance-1_0.xml < translate.patch
	docker run --rm -v $$(pwd):/opt $(IMAGE_NAME) xml2rfc --html openid-connect-4-identity-assurance-1_0.xml
