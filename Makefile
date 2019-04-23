NAME=better/buildkite-agent

all: build publish

build:
	docker build --tag ${NAME} .

publish:
	docker push ${NAME}
