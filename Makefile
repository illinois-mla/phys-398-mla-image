all: image

defualt: image

BASE_IMAGE="jupyter/minimal-notebook:latest"

image:
	docker pull $(BASE_IMAGE)
	docker build \
	-f docker/Dockerfile \
	--build-arg BASE_IMAGE=$(BASE_IMAGE) \
	-t physicsillinois/phys-398-mla:debug-local \
	.