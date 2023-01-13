#!/bin/bash

curl -o /root/.ssh/authorized_keys "$PERSON_PUBLIC_KEY_URL"

# Always has to run last
/usr/sbin/sshd -D
