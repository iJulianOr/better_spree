FROM ruby:2.5.1

RUN apt-get update && apt-get install apt-transport-https

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN apt-get update && \
  apt-get install -y \
  yarn \
  nodejs

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/

ADD package* $APP_HOME/

RUN yarn install
RUN yarn upgrade
RUN yarn add @rails/webpacker@next

ADD . $APP_HOME

ENV BUNDLE_PATH /bundle
