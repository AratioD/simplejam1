#Makefile

SHELL  := /bin/bash

default: help

.PHONY: help  ## @-> show this help  the default action
help:
	@clear
	@fgrep -h "##" $(MAKEFILE_LIST)|fgrep -v fgrep|sed -e 's/^\.PHONY: //'|sed -e 's/^\(.*\)##/\1/'|column -t -s $$'@'

.PHONY: install ## @-> setup the whole environment to run this proj
install: do_build_devops_docker_image do_create_container

.PHONY: install_no_cache ## @-> setup the whole environment to run this proj, do NOT use docker cache
install_no_cache: do_build_devops_docker_image_no_cache do_create_container

.PHONY: run ## @-> run some function , in this case hello world
run:
	./run -a do_run_hello_world

# TODO
.PHONY: do_run ## @-> run some function , in this case hello world
do_run:
	docker exec -it simplejam1-devops-con ./run -a do_run_hello_world

.PHONY: do_build_devops_docker_image ## @-> build the devops docker image
do_build_devops_docker_image:
	docker build . -t simplejam1-devops-img --build-arg UID=$(shell id -u) --build-arg GID=$(shell id -g) -f src/docker/devops/Dockerfile

.PHONY: do_build_devops_docker_image_no_cache ## @-> build the devops docker image
do_build_devops_docker_image_no_cache:
	docker build . -t simplejam1-devops-img --no-cache --build-arg UID=$(shell id -u) --build-arg GID=$(shell id -g) -f src/docker/devops/Dockerfile

.PHONY: do_create_container ## @-> create a new container our of the build img
do_create_container: do_stop_container
	docker run -d -v $$(pwd):/opt/simplejam1 \
	-v $$HOME/.aws:/home/appuser/.aws \
   	-v $$HOME/.ssh:/home/appuser/.ssh \
		--name simplejam1-devops-con simplejam1-devops-img ;
	@echo -e to attach run: "\ndocker exec -it simplejam1-devops-con /bin/bash"
	@echo -e to get help run: "\ndocker exec -it simplejam1-devops-con ./run --help"

.PHONY: do_stop_container ## @-> stop the devops running container
do_stop_container:
	-docker container stop $$(docker ps -aqf "name=simplejam1-devops-con") && docker container rm $$(docker ps -aqf "name=simplejam1-devops-con")

.PHONY: zip_me ## @-> zip the whole project without the .git dir
zip_me:
	-rm -v ../simplejam1.zip ; zip -r ../simplejam1.zip  . -x '*.git*'

demand_var-%:
	@if [ "${${*}}" = "" ]; then \
		echo "the var \"$*\" is not set in the shell!!! Do set it by: export $*='value'"; \
		exit 1; \
	fi

task_which_requires_a_var: demand_var-ENV ## @-> test how-to pass a shell var to this Makefile
	@echo ${ENV}

.PHONY: spawn_tgt_project ## @-> spawn a new target project
spawn_tgt_project: demand_var-TGT_PROJ zip_me
	-rm -r $(shell echo $(dir $(abspath $(dir $$PWD)))$$TGT_PROJ)
	unzip -o ../simplejam1.zip -d $(shell echo $(dir $(abspath $(dir $$PWD)))$$TGT_PROJ)
	to_srch=simplejam1 to_repl=$(shell echo $$TGT_PROJ) dir_to_morph=$(shell echo $(dir $(abspath $(dir $$PWD)))$$TGT_PROJ) ./run -a do_morph_dir

.PHONY: do_prune_docker_system ## @-> stop & completely wipe out all the docker caches for ALL IMAGES !!!
do_prune_docker_system:
	-docker kill $$(docker ps -q)
	-docker rm $$(docker ps -a -q)
	docker builder prune -f --all
	docker system prune -f
