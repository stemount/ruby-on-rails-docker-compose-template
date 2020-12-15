FROM ruby:2.7-buster

# chroot to /app in the container.
WORKDIR /app

# We need the Gemfile quite early.
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Install required dependencies.
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN apt install -y build-essential curl nodejs
RUN apt install -y gawk autoconf automake bison libffi-dev libgdbm-dev libncurses5-dev libsqlite3-dev libtool libyaml-dev pkg-config sqlite3 zlib1g-dev libgmp-dev libreadline-dev libssl-dev

# Debug...
RUN ruby -v

# Install rails.
RUN gem install rails -v 6.1.0

# Install Bundler fixed to 2.2.1
# Apparently it can mimick projects that need bundler v1.
# @see https://bundler.io/blog/2019/01/04/an-update-on-the-bundler-2-release.html
RUN gem install bundler:2.2.1

# Install from Gemfile.
RUN bundle install
RUN bundle update

# Dunno what version it is.
RUN bundle update --bundler

# Copy the project files to /app in the container.
COPY . /app/

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Expose Rails on 3000.
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
