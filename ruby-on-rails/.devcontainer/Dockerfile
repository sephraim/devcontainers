# NOTE This will take precedence over Dockerfile in the project root

# STAGE 1: Initial setup
FROM ruby:3.2.1 as base
WORKDIR /app

# Install missing package(s)
RUN apt-get update -qq && apt-get install -yq --no-install-recommends \
    wait-for-it \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Prep for gem installation
# NOTE: The following `gem update` command is necessary to avoid a RubyGems warning
#       You can keep it, but it's probably not necessary for newer versions of Ruby
RUN gem update --system && gem install bundler

# STAGE 2: Install gems
# NOTE: Copy *only* the files you absolutely need for this stage, otherwise caching will become useless
FROM base as gems
COPY Gemfile Gemfile.lock ./
RUN bundle update --bundler && bundle install

# Install development gems for debugging/documentation
# TODO: Add the following development gems to your Gemfile if you can, then remove this RUN command
RUN gem install debug solargraph-rails

# STAGE 3: Copy gems & project files and build gem executable
FROM base as final
# Copy gems from previous stage
COPY --from=gems /usr/local/bundle /usr/local/bundle
# Copy main app files
COPY Rakefile config.ru  ./
COPY app app
COPY bin bin
COPY config config
COPY db db
COPY lib lib
COPY public public

# Set entrypoint (pre-server) script
COPY entrypoint.sh ./
RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
EXPOSE 3000

# Run the server
COPY run.sh ./
RUN chmod +x run.sh
CMD ["./run.sh"]
