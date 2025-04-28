FROM ruby:3-bullseye
WORKDIR /usr/src/app
RUN apt-get install libmariadb-dev
COPY . .
RUN bundle install
EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]