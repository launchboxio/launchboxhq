FROM ruby:3.1.2

ENV RAILS_ENV production

RUN apt-get update -qq && \
    apt-get install -y \
      ca-certificates \
      curl \
      gnupg
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

RUN apt-get update -qq && \
    apt-get install -y \
      nodejs \
      postgresql-client \
      yarn


COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

WORKDIR /launchbox
COPY Gemfile /launchbox/Gemfile
COPY Gemfile.lock /launchbox/Gemfile.lock
RUN bundle install

COPY . /launchbox

RUN npm install
RUN SECRET_KEY_BASE=`bin/rake secret` rake assets:precompile

RUN mkdir tmp/pids

# Configure the main process to run when running the image
CMD ["bundle", "exec", "puma", "-t", "1:1", "-b", "tcp://0.0.0.0:3000"]
