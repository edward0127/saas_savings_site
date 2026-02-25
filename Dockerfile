# syntax=docker/dockerfile:1
# check=error=true

ARG RUBY_VERSION=3.3.10
FROM docker.io/library/ruby:${RUBY_VERSION}-bookworm AS base

WORKDIR /rails

# Runtime packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl \
      libjemalloc2 \
      libvips \
      sqlite3 \
      libsqlite3-0 && \
    ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test" \
    LD_PRELOAD="/usr/local/lib/libjemalloc.so"

FROM base AS build

# Build packages needed for native gems like sqlite3
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      libyaml-dev \
      pkg-config \
      libsqlite3-dev && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Install gems first for better layer caching
COPY Gemfile Gemfile.lock ./

# If your lockfile was generated on Windows/macOS, this helps Docker Linux builds
RUN BUNDLE_DEPLOYMENT=0 BUNDLE_FROZEN=0 bundle lock --add-platform x86_64-linux && \
    bundle install -j 1 && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile -j 1 --gemfile

# Copy app code after gems
COPY . .

# Precompile bootsnap application code
RUN bundle exec bootsnap precompile -j 1 app/ lib/

# Fix bin files
RUN chmod +x bin/* && \
    sed -i "s/\r$//g" bin/* && \
    sed -i 's/ruby\.exe$/ruby/' bin/*

# Precompile assets without requiring real SECRET_KEY_BASE
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

FROM base

RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    mkdir -p /data /rails/storage /rails/tmp /rails/log && \
    chown -R rails:rails /data /rails/storage /rails/tmp /rails/log

COPY --chown=rails:rails --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --chown=rails:rails --from=build /rails /rails

USER 1000:1000

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server"]