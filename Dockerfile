FROM buildpack-deps:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get clean -qq && \
    apt-get update
RUN apt-get install -y \
      bison build-essential curl git libgdbm3 libgdbm-dev \
      libgsf-1-dev libncurses5-dev libpq-dev libqt5webkit5-dev \
      libreadline6-dev libvips-dev qt5-default
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Docker
ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.11.2
ENV DOCKER_SHA256 8c2e0c35e3cda11706f54b2d46c2521a6e9026a7b13c7d4b8ae1f3a706fc55e1

RUN set -x \
	&& curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-$DOCKER_VERSION.tgz" -o docker.tgz \
	&& echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - \
	&& tar -xzvf docker.tgz \
	&& mv docker/* /usr/local/bin/ \
	&& rmdir docker \
	&& rm docker.tgz \
	&& docker -v

# Install rbenv
ENV RBENV_DIR /root/.rbenv
ENV RBENV_VER v1.0.0
RUN git clone --depth 1 --branch $RBENV_VER -q https://github.com/rbenv/rbenv.git $RBENV_DIR
ENV PATH ${RBENV_DIR}/bin:${RBENV_DIR}/shims:${PATH}
RUN echo 'eval "$(rbenv init -)"' >> $HOME/.bashrc && \
      echo 'eval "$(rbenv init -)"' >> $HOME/.profile && \
      . $HOME/.profile
RUN git clone --depth 1 -q https://github.com/rbenv/ruby-build.git $RBENV_DIR/plugins/ruby-build


# Install nvm
ENV NVM_DIR /usr/local/.nvm
ENV NVM_VER v0.31.3
RUN git clone --depth 1 --branch $NVM_VER https://github.com/creationix/nvm.git $NVM_DIR && \
    cd $NVM_DIR && \
    git checkout `git describe --abbrev=0 --tags`
RUN echo ". ${NVM_DIR}/nvm.sh" > $HOME/.profile && \
    $NVM_DIR/install.sh && \
    . $HOME/.profile


# Install Ruby
ENV RUBY_VERSION 2.3.1
RUN $HOME/.rbenv/bin/rbenv install $RUBY_VERSION && \
    $HOME/.rbenv/bin/rbenv global $RUBY_VERSION

# Install Node
ENV NODE_VERSION 4.4.5
RUN . $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default
ENV NODE_PATH ${NVM_DIR}/v${NODE_VERSION}/lib/node_modules
ENV PATH ${NVM_DIR}/v${NODE_VERSION}/bin:${PATH}
