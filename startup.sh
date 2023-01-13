#!/bin/bash

# Configures user public keys for ssh
curl -o /root/.ssh/authorized_keys "$PERSON_PUBLIC_KEY_URL"

# Pulling backend

# Pulling frontend

# Pulling other required services

# running tilt up

# Always has to run last
/usr/sbin/sshd -D
