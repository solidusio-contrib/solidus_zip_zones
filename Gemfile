# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

branch = ENV.fetch('SOLIDUS_BRANCH', 'master')
gem 'solidus', github: 'solidusio/solidus', branch: branch

# Note1:The solidus_frontend gem has been pulled out since v3.2
# Since we use solidus_frontend and NOT solidus_starter_frontend right now,
# Specifying which frontend we need here ensures that it's not dependent on
# installer default (which now is solidus_starter_frontend)
# Note2: solidus_frontend will be removed from solidus meta-gem
# in Solidus 4 (https://github.com/solidusio/solidus/pull/4490)
# Which will be a breaking change if a store uses solidus_frontend
# but not explicitly included
gem 'solidus_frontend', github: 'solidusio/solidus_frontend' if branch == 'master'
gem 'solidus_frontend' if branch >= 'v3.2' # rubocop:disable Bundler/DuplicatedGem

# Needed to help Bundler figure out how to resolve dependencies,
# otherwise it takes forever to resolve them.
# See https://github.com/bundler/bundler/issues/6677
gem 'rails', '>0.a'

# Provides basic authentication functionality for testing parts of your engine
gem 'solidus_auth_devise'

case ENV.fetch('DB', nil)
when 'mysql'
  gem 'mysql2'
when 'postgresql'
  gem 'pg'
else
  gem 'sqlite3'
end

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3')
  # 'net/smtp' is required by 'mail', see:
  # - https://github.com/ruby/net-protocol/issues/10
  # - https://stackoverflow.com/a/72474475
  gem 'net-smtp', require: false
end

gemspec

# Use a local Gemfile to include development dependencies that might not be
# relevant for the project or for other contributors, e.g. pry-byebug.
#
# We use `send` instead of calling `eval_gemfile` to work around an issue with
# how Dependabot parses projects: https://github.com/dependabot/dependabot-core/issues/1658.
send(:eval_gemfile, 'Gemfile-local') if File.exist? 'Gemfile-local'
