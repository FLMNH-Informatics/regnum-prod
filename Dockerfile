# Runtime image for regnum-prod (Rails 6.1 + puma on Ruby 3.4).
#
# The image holds Ruby and the bundled gems only. The application code is NOT
# copied in: it is bind-mounted at /usr/src/app when the container runs (see
# docker-compose.yml and DEVELOPMENT).
#
# Build with --pull so the base image's Debian and Ruby patches are picked up:
#   docker build --pull -t phyloregnum .
# (On an arm64 machine, add --platform linux/amd64: Gemfile.lock only lists the
# x86_64-linux-gnu platform.)
#
# Why two stages on a -slim base: the old image used the full ruby:3.4-bookworm
# image, which ships git, openssh-client, compilers and dozens of -dev packages
# the app never uses at run time. Vulnerability scans flagged those packages
# (including CISA KEV entries in git, openssh-client and libbrotli-dev), and
# because the base was cached locally, rebuilding never updated them or Ruby.
# Here the compilers and -dev packages stay in the build stage, and only the
# installed gems and the shared libraries they load reach the runtime image.
#
# Pin a Ruby patch release and bump it deliberately. 3.4.12 is the first 3.4.x
# with the Regexp compilation fixes for CVE-2026-97229 and related CVEs
# (https://www.ruby-lang.org/en/news/2026/10/23/regexp-fixes-for-gitlab-cves/).
ARG RUBY_IMAGE=ruby:3.4.12-slim-bookworm

# Gems are installed into this GEM_HOME, the same path the old image used, so
# any existing run command or mount that refers to it keeps working.
ARG GEM_HOME=/usr/src/bundle/ruby/3.4.0/gems

FROM ${RUBY_IMAGE} AS build
ARG GEM_HOME
ENV GEM_HOME=${GEM_HOME}
WORKDIR /usr/src/app

# Native extensions: mysql2 (MariaDB client), rmagick (MagickWand),
# sassc/puma/bcrypt/bigdecimal (C/C++ compiler).
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      build-essential \
      default-libmysqlclient-dev \
      libmagickwand-dev \
      pkg-config \
 && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 \
 && rm -rf "${GEM_HOME}/cache"


FROM ${RUBY_IMAGE}
ARG GEM_HOME
ENV GEM_HOME=${GEM_HOME}
WORKDIR /usr/src/app

# Shared libraries the native gems load, plus the tools paperclip shells out to
# (ImageMagick's convert/identify, and file for content-type detection).
# shared-mime-info provides /usr/share/mime/packages/freedesktop.org.xml, which
# mimemagic (a paperclip dependency) reads at boot; without it the app won't start.
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
      file \
      imagemagick \
      libmagickwand-6.q16-6 \
      libmariadb3 \
      shared-mime-info \
      tzdata \
 && rm -rf /var/lib/apt/lists/*

COPY --from=build ${GEM_HOME} ${GEM_HOME}
COPY Gemfile Gemfile.lock ./

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
