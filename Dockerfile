FROM cruizba/ubuntu-dind:latest

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install -y -qq jq git gh libicu-dev

WORKDIR /home/ubuntu
RUN curl -o actions-runner-linux-x64-2.321.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.321.0/actions-runner-linux-x64-2.321.0.tar.gz
RUN tar xzf ./actions-runner-linux-x64-2.321.0.tar.gz

ADD runner-start.sh runner-start.sh
RUN chmod +x runner-start.sh

# set the entrypoint to the start.sh script
ENTRYPOINT ["./runner-start.sh"]