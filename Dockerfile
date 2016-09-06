FROM ruby:2.2.5

# MACHINE
RUN apt-get update -qq && apt-get install -y build-essential
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# SOURCE DIR
RUN mkdir /src
WORKDIR /src

# LINK GEMS
ADD ./lib/br_danfe/version.rb ./lib/br_danfe/version.rb
ADD ./br_danfe.gemspec ./br_danfe.gemspec
ADD ./Gemfile ./Gemfile
ADD ./Gemfile.lock ./Gemfile.lock

RUN bundle

# LINK SOURCE
ADD ./ ./

