FROM 260741046218.dkr.ecr.us-east-1.amazonaws.com/nvim-ide:latest

RUN curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | bash

RUN apt install -y docker \
  && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

COPY cloud-dev.pub /root/.ssh/authorized_keys

RUN chmod 600 /root/.ssh/authorized_keys
