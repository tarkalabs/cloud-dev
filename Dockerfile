FROM 260741046218.dkr.ecr.us-east-1.amazonaws.com/nvim-ide:latest

WORKDIR /root/work

RUN curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | bash

RUN apt install -y docker \
  && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

RUN wget -O /tmp/kubectl-buildkit.deb https://github.com/vmware-tanzu/buildkit-cli-for-kubectl/releases/download/v0.1.6/kubectl-buildkit_0.1.6_amd64.deb \
  && dpkg -i /tmp/kubectl-buildkit.deb && rm -f /tmp/kubectl-buildkit.deb

COPY startup.sh /root/startup.sh

CMD [ "/root/startup.sh" ]
