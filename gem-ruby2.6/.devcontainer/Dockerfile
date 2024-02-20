# STAGE 1: Initial setup
FROM ruby:3.2.2 as base
WORKDIR /app

# Install missing package(s)
RUN apt-get update -qq && apt-get install -yq --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Prep for gem installation
# NOTE: The following `gem update` command is necessary to avoid a RubyGems warning
#       You can keep it, but it's probably not necessary for newer versions of Ruby
RUN gem update --system && gem install bundler

# STAGE 2: Install gems
# NOTE: Copy *only* the files you absolutely need for this stage, otherwise caching will become useless
FROM base as gemset
COPY Gemfile Gemfile.lock *.gemspec ./
# TODO: Update the path to your version.rb file below
COPY lib/path/to/version.rb lib/path/to/version.rb
RUN bundle update --bundler && bundle install

# Install development gems for debugging/documentation
# TODO: Add the following development gems to your gemspec if you can, then remove this RUN command
RUN gem install debug ruby-debug-ide solargraph

# STAGE 3: Copy gems & project files and build gem executable
FROM base as final
COPY --from=gemset /usr/local/bundle /usr/local/bundle
COPY Gemfile Gemfile.lock *.gemspec Rakefile ./
COPY bin bin
COPY exe exe
COPY lib lib

# Install the gem CLI
RUN bundle exec rake install
# Alternatively, you can run:
# RUN gem build *.gemspec && gem install *.gem

# Keep container running
CMD ["tail", "-f", "/dev/null"]
