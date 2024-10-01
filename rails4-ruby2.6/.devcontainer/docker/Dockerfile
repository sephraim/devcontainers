# STAGE 1: Initial setup
FROM ruby:2.6.10 as base
WORKDIR /app

# Use a bundler version that works for both this version of Ruby and (if applicable) the version of Rails being used
# NOTE: The RubyGems version that comes with Ruby 2.6 contains a bug and must be updated to v3.2.3.
#       Also, Bundler must be pinned to v2.0.0.pre.3 because it is the last version that works with Rails 4.
#       When Rails gets upgraded, the pinned versions can get updated (or possibly removed) below.
ENV BUNDLER_VERSION=2.0.0.pre.3
ARG RUBYGEMS_VERSION=3.2.3

# NOTE: Pinning solargraph version for now because there is a bug with 0.50.0
ARG SOLARGRAPH_VERSION=0.49.0

# Latest gem versions available for Ruby 2.6 as of 2024-09-30
ARG DEBUG_VERSION=1.8.0
ARG PYGMENTS_VERSION=3.0.0
ARG RUBOCOP_VERSION=1.50.2
ARG SOLARGRAPH_RAILS_VERSION=1.1.0

# Install missing package(s)
RUN apt-get update -qq && apt-get install -yq --no-install-recommends \
    imagemagick=8:6.9.11.60+dfsg-1.3+deb11u3 \
    nodejs=12.22.12~dfsg-1~deb11u5 \
    postgis=3.1.1+dfsg-1+deb11u2 \
    postgresql=13+225+deb11u1 \
    wait-for-it=0.0~git20180723-1 \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Prep for gem installation & install gems used for IntelliSense and debugging
# NOTE: You can specify solargraph here (Dockerfile) or in your Gemfile but NOT both,
#       otherwise IntelliSense will not work.
# NOTE: If the debug breakpoint console is not working, you may need to remove 'debug' from the list below
#       and put it in your Gemfile instead.
RUN gem update --system ${RUBYGEMS_VERSION} \
    && gem install bundler:${BUNDLER_VERSION} \
    && gem install pygments.rb:${PYGMENTS_VERSION} \
                   debug:${DEBUG_VERSION} \
                   rubocop:${RUBOCOP_VERSION} \
                   solargraph:${SOLARGRAPH_VERSION} \
                   solargraph-rails:${SOLARGRAPH_RAILS_VERSION}

# STAGE 2: Install gems
# NOTE: Copy *only* the files you absolutely need for this stage, otherwise caching will become useless
FROM base as gems
COPY Gemfile Gemfile.lock ./
COPY vendor vendor
RUN bundle "_${BUNDLER_VERSION}_" update --bundler \
    && bundle "_${BUNDLER_VERSION}_" install

# STAGE 3: Copy main app files & cached gemset
FROM base as final

# Copy cached gemset
COPY --from=gems /usr/local/bundle /usr/local/bundle

# Copy main application files
COPY Gemfile Gemfile.lock Rakefile config.ru ./
COPY app app
COPY bin bin
COPY config config
COPY data data
COPY db db
COPY lib lib
COPY public public
COPY vendor vendor

# Set entrypoint (pre-server) script
COPY .devcontainer/docker/entrypoint.sh ./
RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
EXPOSE 3000

# Run the server
COPY .devcontainer/docker/run.sh ./
RUN chmod +x run.sh
CMD ["./run.sh"]
