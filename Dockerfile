FROM ubuntu:24.04

RUN apt-get update && apt-get install -y sudo

COPY . /server-initializer

CMD ["/bin/bash"]
