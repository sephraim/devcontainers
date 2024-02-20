# STAGE 1: Initial setup
FROM ruby:2.6.10 as base
WORKDIR /app

# Use a bundler version that works for both this version of Ruby and (if applicable) the version of Rails being used
# NOTE: The RubyGems version that comes with Ruby 2.6 contains a bug and must be updated to v3.2.3.
#       Also, Bundler must be pinned to v2.0.0.pre.3 because it is the last version that works with Rails 4.
#       When Rails gets upgraded, the pinned versions can get updated (or possibly removed) below.
ENV BUNDLER_VERSION=2.4.22
ARG RUBYGEMS_VERSION=3.2.3

# NOTE: Pinning solargraph version for now because there is a bug with 0.50.0
ARG SOLARGRAPH_VERSION=0.49.0

# Prep for gem installation & install gems used for IntelliSense and debugging
RUN gem update --system ${RUBYGEMS_VERSION} \
    && gem install bundler:${BUNDLER_VERSION} \
    && gem install debug \
                   pygments.rb \
                   rubocop \
                   solargraph:${SOLARGRAPH_VERSION} \
                   solargraph-rails

# STAGE 2: Install gems
# NOTE: Copy *only* the files you absolutely need for this stage, otherwise caching will become useless
FROM base as gems
COPY Gemfile Gemfile.lock ../*.gemspec ./
COPY path/to/version.rb path/to/version.rb
RUN bundle _${BUNDLER_VERSION}_ update --bundler \
    && bundle _${BUNDLER_VERSION}_ install

# STAGE 3: Install your gem & copy over cached gems
FROM base as final
COPY --from=gems /usr/local/bundle /usr/local/bundle
COPY .. /app

# Install the gem CLI
RUN bundle exec rake install
# Alternatively, you can run:
# RUN gem build *.gemspec && gem install *.gem

# Keep container running
CMD ["tail", "-f", "/dev/null"]
