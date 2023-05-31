FROM elixir:1.12-alpine

# Install Git
RUN apk add --no-cache git

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ v0.13.0
RUN apk --update add git && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

# Configure git to recognize /github/workspace as a safe directory
RUN git config --global --add safe.directory /github/workspace

ENV MIX_HOME /var/mix

RUN mix local.hex --force && \
    mix archive.install --force github rrrene/bunt && \
    mix archive.install --force github rrrene/credo

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
