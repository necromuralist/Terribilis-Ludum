# This uses the official Docker pypy image (using debian)

ARG IMAGE_NAME=pypy
ARG VERSION=3.10-7.3.12-bookworm
FROM ${IMAGE_NAME}:${VERSION}

# Set timezone to avoid apt-get dialog asking what timezone you're in
# https://askubuntu.com/questions/909277/avoiding-user-interaction-with-tzdata-when-installing-certbot-in-a-docker-contai/1098881#1098881

# RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone

# this will also work but it suppresses all dialog boxes instead of setting up the timezone
# ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    openssh-server \
    rsync \
    screen \
    zile \
    virtualenv && \
    useradd --create-home --shell /bin/bash terribilis && \
    ln -s /usr/local/bin/pypy3 /usr/local/bin/python

# this requires docker-buildkit to be turned on
# (environment variable DOCKER_BUILDKIT=1)
# (the cache won't keep downloading dependencies)
# unless there's a change
RUN --mount=type=cache,target=/root/.cache \
    pypy3 -m pip install --upgrade pip

# *** setup user terribilis *** #
# switch from root to terribilis
USER terribilis
WORKDIR /home/terribilis

COPY --chown=terribilis:terribilis authorized_keys .ssh/authorized_keys
COPY --chown=terribilis:terribilis requirements.txt .
COPY --chown=terribilis:terribilis screenrc .screenrc

# define our virtualenv paths
ENV VIRTUALENVS=.virtualenvs
ENV VIRTUALENV=$VIRTUALENVS/terribilis-ludum

# setup the virtualenv
RUN mkdir $VIRTUALENVS && \
    pypy3 -m venv $VIRTUALENV

ENV PATH="$VIRTUALENV/bin:$PATH"

RUN pypy3 -m ensurepip
# install wheel outside of the requirements file
# otherwise the other packages in the file won't be able to use it
# when you install them from the requirements file
RUN --mount=type=cache,target=/root/.cache \
    pypy3 -m pip --no-cache-dir install --upgrade wheel && \
    pypy3 -m pip --no-cache-dir install -r requirements.txt

# setup the bashrc to activate the virtulaenv when terribilis logs in
RUN echo 'source ~/.virtualenvs/terribilis-ludum/bin/activate' >> .bashrc
RUN echo  'export PATH=$PATH:$HOME/.local/bin' >> .bashrc

# *** Go back to root or the ssh-server will fail when you start the container *** #
USER root
WORKDIR /
ENTRYPOINT service ssh restart && bash
