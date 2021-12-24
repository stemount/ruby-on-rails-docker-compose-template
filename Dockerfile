FROM ruby:alpine

# chroot to /app in the container.
WORKDIR /app

# We need the Gemfile quite early.
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN cat /etc/alpine-release

# Install required dependencies.
RUN echo 'https://dl-cdn.alpinelinux.org/alpine/latest-stable/main' >> /etc/apk/repositories
RUN echo 'https://dl-cdn.alpinelinux.org/alpine/latest-stable/community' >> /etc/apk/repositories

# Developers love these tools.
RUN apk add --update --no-cache curl wget jq htop

# SQLite3 requires Python3 to work.
RUN apk add --update --no-cache py3-configobj py3-pip py3-setuptools \
    python3 python3-dev
RUN apk add --update --no-cache nodejs postgresql-client curl nodejs ruby

# Add build tools.
# RUN apk add --update --no-cache gawk autoconf automake bison libffi-dev gbdm \
#     libncurses5-dev libtool libyaml-dev \
#     pkg-config zlib1g-dev libgmp-dev libreadline-dev libssl-dev

# Mimetypes are required to build railties-6.1.0
RUN apk add --update --no-cache shared-mime-info

RUN apk add --update --no-cache gawk autoconf automake bison \
    libffi-dev libtool make gcc libc-dev

# SQLite 3 is useful for testing apps in RAM and/or with SQLite flat file structure.
RUN apk add --update --no-cache sqlite

# Debug...
RUN make -v && ruby -v

# Install rails.
RUN gem install rails

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
