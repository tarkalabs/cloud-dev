#!/bin/bash
set -xe

# Configures user public keys for ssh
curl -o /root/.ssh/authorized_keys "$PERSON_PUBLIC_KEY_URL"

# changing directory to tilt
cd tilt

# we can use git submodules and can keep all at one place with different branches
# Pulling frontend
# check if folder already exists and skip
git clone git@github.com:SVMadhavaReddy/cloud-dev-frontend.git

tilt up

# Pulling backend
# git clone git@github.com:SVMadhavaReddy/cloud-dev-backend.git
# simple flaskapp

# Pulling other required services
# follow above approach

# running tilt up
# where should we have tilt file?

# Always has to run last
/usr/sbin/sshd -D
