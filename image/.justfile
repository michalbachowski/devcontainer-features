_default:
	just --list

build-debian push="false":
	docker buildx build \
		--tag bachowskimichal/devcontainer-test-debian:v3 \
		--file debian.Dockerfile \
		--push={{ push }} \
		.

build-ubuntu push="false":
	cd image && \
	docker buildx build \
		--tag bachowskimichal/devcontainer-test-ubuntu:v3 \
		--file ubuntu.Dockerfile \
		--push={{ push }} \
		.

build-all push="false": (build-ubuntu push) (build-debian push)
	@echo Done
