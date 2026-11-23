FROM ruby:3.4-bookworm
ENV GEM_HOME=/usr/src/bundle/ruby/3.4.0/gems
WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN apt update && apt upgrade -y
RUN apt purge --auto-remove openssh-server
RUN bundle config --set-path /usr/src/bundle \
 && bundle install 

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]