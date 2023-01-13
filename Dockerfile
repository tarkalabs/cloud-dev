FROM 260741046218.dkr.ecr.us-east-1.amazonaws.com/nvim-ide:latest

WORKDIR /root/work

RUN curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | bash

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip \
  && unzip -d /tmp /tmp/awscliv2.zip \
  && sudo /tmp/aws/install \
  && rm -rf /tmp/aws /tmp/awscliv2.zip

RUN curl "https://storage.googleapis.com/kubernetes-release/release/v1.24.8/bin/linux/amd64/kubectl" -o /tmp/kubectl \
  && sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl \
  && rm -f /tmp/kubectl

RUN wget -O /tmp/kubectl-buildkit.deb https://github.com/vmware-tanzu/buildkit-cli-for-kubectl/releases/download/v0.1.6/kubectl-buildkit_0.1.6_amd64.deb \
  && dpkg -i /tmp/kubectl-buildkit.deb && rm -f /tmp/kubectl-buildkit.deb

COPY startup.sh /root/startup.sh

CMD [ "/root/startup.sh" ]
