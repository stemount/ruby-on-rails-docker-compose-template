FROM ruby:2.7-alpine

# chroot to /app in the container.
WORKDIR /app

# We need the Gemfile quite early.
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN cat /etc/alpine-release

# Install required dependencies.
RUN echo 'https://dl-cdn.alpinelinux.org/alpine/latest-stable/main' >> /etc/apk/repositories
RUN echo 'https://dl-cdn.alpinelinux.org/alpine/latest-stable/community' >> /etc/apk/repositories

RUN apk add --update --no-cache curl jq py3-configobj py3-pip py3-setuptools python3 python3-dev
RUN apk add --update --no-cache nodejs postgresql-client curl nodejs gawk autoconf automake bison libffi-dev gbdm libncurses5-dev libsqlite3-dev libtool libyaml-dev pkg-config sqlite3 zlib1g-dev libgmp-dev libreadline-dev libssl-dev

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
