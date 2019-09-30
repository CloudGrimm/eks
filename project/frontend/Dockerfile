FROM awselscpt/frontend-base

RUN mkdir /app
WORKDIR /app

ADD Gemfile Gemfile.lock /app/
RUN bundle install -j 8

ADD . /app

EXPOSE 4567

CMD ["./app.rb"]
