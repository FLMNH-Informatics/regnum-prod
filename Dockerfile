FROM ruby:3-bullseye
WORKDIR /usr/src/app
ENV GEM_HOME=/usr/src/bundle/ruby/3.4.0/gems
RUN apt-get install libmariadb-dev
COPY Gemfile Gemfile.lock ./
RUN bundle config --set-path /usr/src/bundle && bundle install
EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]