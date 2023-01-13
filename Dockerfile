FROM 260741046218.dkr.ecr.us-east-1.amazonaws.com/nvim-ide:latest

WORKDIR /root/work

RUN curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | bash

RUN apt install -y docker \
  && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

COPY startup.sh startup.sh

CMD [ "startup.sh" ]
