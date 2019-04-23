FROM alpine:3.9

RUN apk add --no-cache \
      bash \
      git \
      perl \
      rsync \
      openssh-client \
      curl \
      docker \
      jq \
      su-exec \
      py-pip \
      libc6-compat \
      run-parts \
      tini \
      tzdata \
    && \
    pip install --upgrade pip && \
    pip install --quiet docker-compose~=1.23.0

ENV BUILDKITE_AGENT_CONFIG=/buildkite/buildkite-agent.cfg

RUN mkdir -p /buildkite/builds /buildkite/hooks /buildkite/plugins \
    && curl -Lfs -o /usr/local/bin/ssh-env-config.sh https://raw.githubusercontent.com/buildkite/docker-ssh-env-config/master/ssh-env-config.sh \
    && chmod +x /usr/local/bin/ssh-env-config.sh

RUN mkdir -p /tmp/bk && \
  curl -L --output - https://github.com/buildkite/agent/releases/download/v3.11.2/buildkite-agent-linux-amd64-3.11.2.tar.gz > /tmp/bk/bk.tar.gz && \
  cd /tmp/bk && \
  tar -xvzf bk.tar.gz && \
  mv buildkite-agent /usr/local/bin/buildkite-agent && \
  chmod +x /usr/local/bin/buildkite-agent

COPY ./buildkite-agent.cfg /buildkite/buildkite-agent.cfg
COPY ./entrypoint.sh /usr/local/bin/buildkite-agent-entrypoint

VOLUME /buildkite
ENTRYPOINT ["buildkite-agent-entrypoint"]
CMD ["start"]
