# Base off the ubuntu 14.04 release, rbenv and ruby 2.1.2
# https://registry.hub.docker.com/u/rusllonrails/ubuntu_1404_rbenv_ruby_2/
FROM rusllonrails/ubuntu_1404_rbenv_ruby_2

# Create rbenv gemset and install bundler
RUN /bin/bash -l -c "echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc && rbenv rehash"
RUN /bin/bash -l -c "gem update rubygems"

ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN /bin/bash -l -c "bundle install"

RUN mkdir /trade-tariff-backend
ADD . /trade-tariff-backend
WORKDIR /trade-tariff-backend

RUN /bin/bash -l -c "bundle install"
