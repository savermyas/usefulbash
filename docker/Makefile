# This file prepares a Docker enviroment in current directory
# with bin\ folder that containt executable binaries and
# data\ folder for Docker graph data. It also creates a symlink
# to Docker executable file and a script to run Docker daemon
# in user's home bin/ directory.

DOCKER_VERSION=17.12.0-ce
DOCKER_HOME=$(HOME)/docker
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
	rm -f $(DOCKER_HOME)/bin/*

$(DOCKER_INSTALLATION) :
	mkdir -p downloads
	curl https://download.docker.com/linux/static/stable/x86_64/docker-$(DOCKER_VERSION).tgz > $@

$(DOCKER_HOME)/bin/docker : $(DOCKER_INSTALLATION)
	mkdir -p $(DOCKER_HOME)/bin $(DOCKER_HOME)/data $(DOCKER_HOME)/log $(DOCKER_HOME)/run tmp
	tar xvf $(DOCKER_INSTALLATION) -C tmp/
	cp -r tmp/docker/* $(DOCKER_HOME)/bin/
	rm -rf tmp

$(DOCKER_HOME)/bin/docker-compose :
	mkdir -p bin
	curl -L https://github.com/docker/compose/releases/download/$(DOCKER_COMPOSE_VERSION)/docker-compose-Linux-x86_64 > $@

$(DOCKER_BIN) : $(DOCKER_HOME)/bin/docker
	ln -fs $(DOCKER_HOME)/bin/docker $(HOME)/bin/docker
	ln -fs $(DOCKER_HOME)/bin/docker-containerd $(HOME)/bin/docker-containerd
	chmod +x $@

$(DOCKER_COMPOSE_BIN) : $(DOCKER_HOME)/bin/docker-compose
	ln -fs $(DOCKER_HOME)/bin/docker-compose $(HOME)/bin/docker-compose
	chmod +x $@

$(DOCKERD_ENV) :
	echo export PATH=\"$(PATH):$(DOCKER_HOME)/bin\" > $@
	echo DOCKERD_BIN=\"$(DOCKER_HOME)/bin/dockerd\" >> $@
	echo DOCKERD_PID=\"$(DOCKER_HOME)/run/dockerd.pid\" >> $@
	echo DOCKERD_LOG=\"$(DOCKER_HOME)/log/dockerd.log\" >> $@
	echo DOCKERD_ERR=\"$(DOCKER_HOME)/log/dockerd.err\" >> $@
	echo DOCKERD_OPTS=\"--data-root $(DOCKER_HOME)/data \
                            --pidfile $(DOCKER_HOME)/run/dockerd.pid \
                            --exec-root $(DOCKER_HOME)/run/\
                            \" >> $@

$(DOCKERD_SCRIPT) :
	cp dockerd $@
	chmod +x $@

install : $(DOCKER_BIN) $(DOCKER_COMPOSE_BIN) $(DOCKERD_ENV) $(DOCKERD_SCRIPT)
