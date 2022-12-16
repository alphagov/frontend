ARG base_image=ghcr.io/alphagov/govuk-ruby-base:3.1.2
ARG builder_image=ghcr.io/alphagov/govuk-ruby-builder:3.1.2

FROM $builder_image AS builder

RUN apt-get update -qy && \
    apt-get upgrade -y && \
    apt-get install -y build-essential nodejs git

RUN mkdir /app

WORKDIR /app

COPY Gemfile* .ruby-version ./
RUN bundle install

COPY . /app
RUN bundle exec rails assets:precompile && rm -rf /app/log


FROM $base_image

ENV GOVUK_APP_NAME=frontend

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /app /app/

USER app
WORKDIR /app

CMD ["bundle", "exec", "puma"]
