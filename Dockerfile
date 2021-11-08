ARG BASE_LINUX_IMAGE=3-buster
FROM ruby:${BASE_LINUX_IMAGE}

WORKDIR /app

# # We need the Gemfile quite early.
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Set debconf to run non-interactively
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update -y --fix-missing
RUN apt-get install -y -q --no-install-recommends build-essential \
    postgresql-client \
    curl \
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
    libssl-dev \
    vim \
    wget \
    net-tools \
    dnsutils

SHELL [ "/bin/bash", "-l", "-c" ]

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
RUN source /root/.bashrc && nvm install --lts && nvm use --lts && nvm alias default $(node -v)

# Install Node.js dependencies for Sass.
RUN npm install -g npm@latest
RUN npm install -g sass@latest

# Install/Update from Gemfile.
RUN bundle install

# # Copy the project files to /app in the container.
COPY . /app/

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Expose Rails on port 3000.
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
