# This file prepares a Docker enviroment in current directory
# with bin\ folder that containt executable binaries and
# data\ folder for Docker graph data. It also creates a symlink
# to Docker executable file and a script to run Docker daemon
# in user's home bin/ directory.

DOCKER_VERSION=17.04.0-ce
DOCKER_INSTALLATION=downloads/docker-$(DOCKER_VERSION).tgz
DOCKER_BIN=$(HOME)/bin/docker

DOCKER_COMPOSE_VERSION=1.12.0
DOCKER_COMPOSE_BIN=$(HOME)/bin/docker-compose

DOCKERD_ENV=$(HOME)/bin/dockerd.env
DOCKERD_SCRIPT=$(HOME)/bin/dockerd

.PHONY : clean update


clean :
	rm -f $(DOCKERD_ENV)
	rm -f $(DOCKERD_SCRIPT)
	rm -f $(DOCKER_BIN)
	rm -f $(DOCKER_COMPOSE_BIN)
	rm -f $(shell readlink -f bin/docker)
	rm -f $(shell readlink -f bin/docker-compose) 

$(DOCKER_INSTALLATION) :
	mkdir -p downloads
	curl https://get.docker.com/builds/Linux/x86_64/docker-$(DOCKER_VERSION).tgz > $@

$(shell readlink -f bin/docker) : $(DOCKER_INSTALLATION)
	mkdir -p bin data log run tmp
	tar xvf $(DOCKER_INSTALLATION) -C tmp/
	cp -r tmp/docker/* bin/
	rm -rf tmp

$(shell readlink -f bin/docker-compose) :
	mkdir -p bin
	curl https://github.com/docker/compose/releases/download/$(DOCKER_COMPOSE_VERSION)/docker-compose-Linux-x86_64 > $@

$(DOCKER_BIN) : $(shell readlink -f bin/docker)
	ln -fs $(shell readlink -f bin/docker) $(HOME)/bin/docker
	ln -fs $(shell readlink -f bin/docker-containerd) $(HOME)/bin/docker-containerd
	chmod +x $@

$(DOCKER_COMPOSE_BIN) : $(shell readlink -f bin/docker-compose)
	ln -fs $(shell readlink -f bin/docker-compose) $(HOME)/bin/docker-compose
	chmod +x $@

$(DOCKERD_ENV) :
	echo export PATH=\"$(PATH):$(shell readlink -f bin)\" > $@
	echo DOCKERD_BIN=\"$(shell readlink -f bin/dockerd)\" >> $@
	echo DOCKERD_PID=\"$(shell readlink -f run/dockerd.pid)\" >> $@
	echo DOCKERD_LOG=\"$(shell readlink -f log/dockerd.log)\" >> $@
	echo DOCKERD_ERR=\"$(shell readlink -f log/dockerd.err)\" >> $@
	echo DOCKERD_OPTS=\"-g $(shell readlink -f data) \
                            --pidfile $(shell readlink -f run/dockerd.pid) \
                            --exec-root $(shell readlink -f run/)\
                            \" >> $@

$(DOCKERD_SCRIPT) :
	cp dockerd $@
	chmod +x $@

install : $(DOCKER_BIN) $(DOCKER_COMPOSE_BIN) $(DOCKERD_ENV) $(DOCKERD_SCRIPT)
