FROM macool/baseimage-rbenv-docker:latest

# Install ruby and gems
RUN rbenv install 2.1.2
RUN rbenv global 2.1.2

RUN echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc

RUN gem install bundler --no-ri --no-rdoc
RUN rbenv rehash

# make sure we have libcurl and libmysqlclient-dev
RUN apt-get install -qqy libcurl4-openssl-dev libmysqlclient-dev

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# set $HOME
RUN echo "/root" > /etc/container_environment/HOME
# and workdir
RUN mkdir /trade-tariff-backend
WORKDIR /trade-tariff-backend

# let's copy and bundle backend
ADD . /trade-tariff-backend
RUN bundle install
