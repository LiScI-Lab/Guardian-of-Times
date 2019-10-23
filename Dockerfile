FROM ruby:2.6.3-alpine

EXPOSE 3000
RUN mkdir application
ADD Gemfile* application/

ENV RAILS_ENV production
ENV TZ Europe/Berlin
ENV RAILS_MASTER_KEY key

WORKDIR /application

RUN apk add --no-cache postgresql-dev npm && \
  apk add --no-cache build-base libxml2-dev libxslt-dev && \
  gem install bundler && \
  bundle config build.nokogiri --use-system-libraries && \
  bundle install --without="development test" && \
  apk del --no-cache build-base && \
  apk add --no-cache libxml2 libxslt tzdata

ADD . /application

ENTRYPOINT ["./start.sh"]
