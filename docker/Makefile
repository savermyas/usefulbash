# This file prepares a Docker enviroment in current directory
# with bin\ folder that containt executable binaries and
# data\ folder for Docker graph data. It also creates a symlink
# to Docker executable file and a script to run Docker daemon
# in user's home bin/ directory.

DOCKER_VERSION=17.04.0-ce
DOCKER_INSTALLATION=downloads/docker-$(DOCKER_VERSION).tgz

DOCKERD_ENV=$(HOME)/bin/dockerd.env
DOCKERD_SCRIPT=$(HOME)/bin/dockerd

.PHONY : clean update

$(DOCKER_INSTALLATION) :
	mkdir -p downloads
	curl https://get.docker.com/builds/Linux/x86_64/docker-$(DOCKER_VERSION).tgz > $(DOCKER_INSTALLATION)

clean :
	rm -f $(DOCKERD_ENV)
	rm -f $(DOCKERD_SCRIPT)
#	rm -rf downloads/*

update : $(DOCKER_INSTALLATION) $(DOCKERD_ENV) $(DOCKERD_SCRIPT)
	mkdir -p bin data log run tmp
	tar xvf $(DOCKER_INSTALLATION) -C tmp/
	cp -r tmp/docker/* bin/
	rm -rf tmp
	ln -fs $(shell readlink -f bin/docker) $(HOME)/bin/docker
	ln -fs $(shell readlink -f bin/docker-containerd) $(HOME)/bin/docker-containerd

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
	cp dockerd $(DOCKERD_SCRIPT)
	chmod +x $(DOCKERD_SCRIPT)
