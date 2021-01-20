FROM ubuntu:18.04
LABEL maintainer="Freckle Engineering <freckle-engeering@renaissance.com>"
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Base tools
RUN \
  apt-get update -y && \
  apt-get install --no-install-recommends -y \
    awscli \
    ca-certificates \
    curl \
    jq \
    make \
    python3 \
    python3-pip \
    python3-setuptools \
    unzip && \
  rm -rf /var/lib/apt/lists/*

# For converting Stack templates between JSON and Yaml
RUN pip3 install cfn-flip==1.2.3

# For deploying CloudFormation Stacks with better UI/UX
RUN \
  cd /tmp && \
  curl --location --remote-name \
    https://github.com/aws-cloudformation/rain/releases/download/v1.1.1/rain-v1.1.1_linux-amd64.zip && \
  unzip rain-v1.1.1_linux-amd64.zip && \
  cp ./rain-v1.1.1_linux-amd64/rain /bin/rain && \
  cd - && \
  rm -rf /tmp/rain-*

# For downloading the private GitHub assets
RUN \
  curl --location --output /bin/ghrd \
    https://github.com/zero88/gh-release-downloader/releases/download/v1.1.1/ghrd && \
  chmod +x /bin/ghrd

COPY files/ /
COPY PLATFORM_VERSION /PLATFORM_VERSION
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["platform", "--help"]
