FROM ruby:3.1.2

RUN apt-get update -qq && \
    apt-get install -y \
      nodejs \
      postgresql-client

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

WORKDIR /launchbox
COPY Gemfile /launchbox/Gemfile
COPY Gemfile.lock /launchbox/Gemfile.lock
RUN bundle install

COPY . /launchbox
# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]