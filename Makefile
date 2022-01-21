all: image

defualt: image

image:
	docker build \
	-f docker/Dockerfile \
	--build-arg BASE_IMAGE=jupyter/minimal-notebook:latest \
	-t physicsillinois/phys-398-mla:debug-local \
	.
