FROM ruby:2.5.1

LABEL maintainer="Scott Horsfield <shhorsfi@amazon.com>"

RUN apt-get update && apt-get install -y graphicsmagick

RUN mkdir /app
WORKDIR /app

ENV RAILS_SERVE_STATIC_FILES true
ENV AWS_REGION=us-west-2

COPY Gemfile Gemfile.lock ./
RUN bundle install --binstubs

COPY . .

ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.2.1/wait /wait
RUN chmod +x /wait

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["/entrypoint.sh"]
CMD puma -C config/puma.rb