FROM docker:stable-dind

WORKDIR /home/docker/actions-runner
RUN apk add curl
RUN curl -o actions-runner-linux-x64.tar.gz -L https://github.com/actions/runner/releases/download/v2.305.0/actions-runner-linux-x64-2.305.0.tar.gz
RUN tar xzf ./actions-runner-linux-x64.tar.gz

USER docker

RUN sudo chown -R docker ~docker 
RUN /home/docker/actions-runner/bin/installdependencies.sh

# add over the start.sh script
ADD start_runner.sh start_runner.sh

# make the script executable
RUN chmod +x start_runner.sh



ENTRYPOINT ["./start_runner.sh"]