FROM debian:8.7

# Install packages
RUN apt-get update \
    && apt-get -y install curl bash openssl python-pip openssh-client unzip vim \
    && pip install awscli


ENV VERSION_DOCKER_CLI 1.13.0
ENV VERSION_DOCKER_COMPOSE 1.10.1
ENV VERSION_DOCKER_MACHINE v0.9.0
ENV VERSION_DOCKER_MACHINE_SCALEWAY 1.3

ENV VERSION_TERRAFORM 0.8.5
ENV VERSION_TERRAGRUNT v0.9.8

# the mountpoint, where docker-machine should store it's config files
ENV MACHINE_STORAGE_PATH /root/.docker/machine

WORKDIR /data

# docker-compose
RUN curl -L https://github.com/docker/compose/releases/download/${VERSION_DOCKER_COMPOSE}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# # docker-client
RUN curl -L https://get.docker.com/builds/Linux/x86_64/docker-${VERSION_DOCKER_CLI}.tgz > /tmp/outdocker.tgz \
    && tar xvzfO /tmp/outdocker.tgz docker/docker > /usr/local/bin/docker \
    && chmod +x /usr/local/bin/docker && rm -rf /tmp/outdocker.tgz

# # docker-machine
RUN curl -L https://github.com/docker/machine/releases/download/${VERSION_DOCKER_MACHINE}/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine && chmod +x /usr/local/bin/docker-machine

# # docker-machine-scaleway
RUN curl -L https://github.com/scaleway/docker-machine-driver-scaleway/releases/download/v${VERSION_DOCKER_MACHINE_SCALEWAY}/docker-machine-driver-scaleway_${VERSION_DOCKER_MACHINE_SCALEWAY}_linux_amd64.tar.gz > /tmp/outscale.tar.gz \
    && tar xvzfO /tmp/outscale.tar.gz docker-machine-driver-scaleway_${VERSION_DOCKER_MACHINE_SCALEWAY}_linux_amd64/docker-machine-driver-scaleway > /usr/local/bin/docker-machine-driver-scaleway \
    && chmod +x /usr/local/bin/docker-machine-driver-scaleway && rm -rf /tmp/outscale.tar.gz

# terragrunt
RUN curl -L https://github.com/gruntwork-io/terragrunt/releases/download/${VERSION_TERRAGRUNT}/terragrunt_`uname -s`_-`uname -m` > /usr/local/bin/terragrunt && chmod +x /usr/local/bin/terragrunt

# terraform
RUN curl -L https://releases.hashicorp.com/terraform/${VERSION_TERRAFORM}/terraform_${VERSION_TERRAFORM}_linux_amd64.zip > /tmp/terraform.zip \
    && cd /tmp && ls && unzip terraform.zip && mv terraform /usr/local/bin/terraform && chmod +x /usr/local/bin/terraform && rm -rf /tmp/terraform*

COPY .docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/bin/bash", "--login"]
