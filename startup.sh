#!/bin/bash
set -xe

# Configures user public keys for ssh
curl -o /root/.ssh/authorized_keys "$PERSON_PUBLIC_KEY_URL"

# configures kubeconfig
aws eks update-kubeconfig --region us-east-1 --name cloud-dev --alias cloud-dev

# cloning cloud-dev infra source code
if [[ -d "cloud-dev" && -d "cloud-dev/.git" ]]; then
  echo "Cloud dev repo already exists!"
else
  git clone https://github.com/tarkalabs/cloud-dev.git
fi

# we can use git submodules and can keep all at one place with different branches
# Pulling frontend
if [[ -d "cloud-dev-frontend" && -d "cloud-dev-frontend/.git" ]]; then
  echo "Frontend repo already exists!"
else
  git clone https://github.com/SVMadhavaReddy/cloud-dev-frontend.git
fi

# Pulling backend
if [[ -d cloud-dev-frontend && -d "cloud-dev-backend/.git" ]]; then
  echo "Backend repo already exists!"
else
  git clone https://github.com/SVMadhavaReddy/cloud-dev-backend.git
fi

# running tilt up
# where should we have tilt file?

# Always has to run last
/usr/sbin/sshd -D
