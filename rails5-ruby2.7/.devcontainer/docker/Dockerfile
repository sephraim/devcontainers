# STAGE 1: Initial setup
FROM ruby:2.7.7 as base
WORKDIR /app

# Use a bundler version that works for both this version of Ruby and (if applicable) the version of Rails being used
# NOTE: Bundler v2.4.22 is the last version that works with Ruby 2.7.
#       RubyGems v3.4.22 is the last version that works with Ruby 2.7.
#       When Ruby gets upgraded, the version flags can be updated below.
ENV BUNDLER_VERSION=2.4.22
ARG RUBYGEMS_VERSION=3.4.22

# NOTE: Pinning solargraph version for now because there is a bug with 0.50.0
ARG SOLARGRAPH_VERSION=0.49.0

# NOTE: debug requires psych, but psych 4+ has major breaking changes for older Ruby / Rails versions
#       More info at: https://stackoverflow.com/a/71192990/990637
#       So stick with psych 3.x until Ruby / Rails get updated on this project
ARG PSYCH_VERSION=3.3.4

# Install missing package(s)
RUN apt-get update -qq && apt-get install -yq --no-install-recommends \
    nodejs \
    wait-for-it \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Prep for gem installation & install gems used for IntelliSense and debugging
# NOTE: You can specify solargraph here (Dockerfile) or in your Gemfile but NOT both,
#       otherwise IntelliSense will not work.
# NOTE: If the debug breakpoint console is not working, you may need to remove 'debug' from the list below
#       and put it in your Gemfile instead.
RUN gem update --system ${RUBYGEMS_VERSION} \
    && gem install bundler:${BUNDLER_VERSION} \
    && gem install pygments.rb \
                   debug \
                   psych:${PSYCH_VERSION} \
                   rubocop \
                   solargraph:${SOLARGRAPH_VERSION} \
                   solargraph-rails

# STAGE 2: Install gems
# NOTE: Copy *only* the files you absolutely need for this stage, otherwise caching will become useless
FROM base as gems
COPY Gemfile Gemfile.lock ./
COPY vendor vendor
RUN bundle _${BUNDLER_VERSION}_ update --bundler \
    && bundle _${BUNDLER_VERSION}_ install

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
