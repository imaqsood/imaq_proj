ARG RUBY_VERSION=3.2.1
FROM ruby:$RUBY_VERSION-bullseye As base

ARG USER_ID=1000
ARG GROUP_ID=1000

ARG RUBY_VERSION
ARG NODE_VERSION=19

ENV RAILS_ENV="${RAILS_ENV}" \
    NODE_ENV="${NODE_ENV}" \
    USER="docker" \
    APP_PATH="/opt/app" \
    BUNDLE_PATH="/usr/local/bundle"

# System Dependencies
RUN bash -c "set -o pipefail && apt-get update \
  && apt-get install -y --no-install-recommends build-essential curl git libpq-dev vim nano \
  && curl -fsSL https://deb.nodesource.com/setup_19.x | bash - \
  && curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb https://dl.yarnpkg.com/debian/ stable main' | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update && apt-get install -y --no-install-recommends nodejs yarn \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean"

RUN gem install bundler

# Create a user and group
RUN echo $GROUP_ID && addgroup --gid $GROUP_ID docker && \
    adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID docker

RUN mkdir -p $APP_PATH
RUN chown -R docker:docker $APP_PATH
RUN chown -R docker:docker $BUNDLE_PATH

COPY bin/start  /usr/bin/
RUN chmod +x /usr/bin/start

ENTRYPOINT ["start"]

WORKDIR $APP_PATH

USER $USER_ID

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

#========================== DEVELOPMENT ===========================
FROM base AS development

ENV RAILS_ENV=development \
    NODE_ENV=development

#========================== PRODUCTION ===========================
FROM base AS production

ENV RAILS_ENV=production \
    NODE_ENV=production

COPY --chown=docker:docker . .

RUN bundle install

USER $USER_ID
