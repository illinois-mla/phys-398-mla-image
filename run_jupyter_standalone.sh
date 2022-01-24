#!/usr/bin/env bash

function main() {
  #1: path to lab
  local path_to_lab
  path_to_lab="${1}"
  path_to_lab_dir="$(dirname "${path_to_lab}")"

  IMAGE="physicsillinois/phys-398-mla:spring-2022"

  docker pull "${IMAGE}"
  docker run \
    --rm \
    -it \
    -v "$PWD/${path_to_lab_dir}":/home/jovyan/work \
    -w /home/jovyan/work \
    -p 8080:8080 \
    "${IMAGE}"
}

main "$@" || exit 1
