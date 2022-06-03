FROM ruby:buster

# chroot to /app in the container.
WORKDIR /app

# We need the Gemfile quite early.
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Install required dependencies.
RUN apt-get update -qq
RUN apt-get install -y build-essential \
    nodejs \
    postgresql-client \
    curl \
    nodejs \
    gawk \
    autoconf \
    automake \
    bison \
    libffi-dev \
    libgdbm-dev \
    libncurses5-dev \
    libsqlite3-dev \
    libtool \
    libyaml-dev \
    pkg-config \
    sqlite3 \
    zlib1g-dev \
    libgmp-dev \
    libreadline-dev \
    libssl-dev

# Developers are ultimately gonna install these anyway.
RUN apt-get install -y nano \
    vim \
    wget

# Install rails.
RUN gem install rails -v 7

# Debug...
RUN ruby -v

# Install Bundler fixed to 2.2.1
# Apparently it can mimick projects that need bundler v1.
# @see https://bundler.io/blog/2019/01/04/an-update-on-the-bundler-2-release.html
RUN gem install bundler

# Install from Gemfile.
RUN bundle install

# Copy the project files to /app in the container.
COPY . /app/

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Expose Rails on port 3000.
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
