# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

branch = ENV.fetch('SOLIDUS_BRANCH', 'main')
gem 'solidus', github: 'solidusio/solidus', branch: branch

# Note1:The solidus_frontend gem has been pulled out since v3.2
# Since we use solidus_frontend and NOT solidus_starter_frontend right now,
# Specifying which frontend we need here ensures that it's not dependent on
# installer default (which now is solidus_starter_frontend)
# Note2: solidus_frontend will be removed from solidus meta-gem
# in Solidus 4 (https://github.com/solidusio/solidus/pull/4490)
# Which will be a breaking change if a store uses solidus_frontend
# but not explicitly included

# The solidus_frontend gem has been pulled out since v3.2
if branch >= 'v3.2'
  gem 'solidus_frontend'
elsif branch == 'main'
  gem 'solidus_frontend', github: 'solidusio/solidus_frontend'
else
  gem 'solidus_frontend', github: 'solidusio/solidus', branch: branch
end

rails_version = ENV.fetch('RAILS_VERSION', '~> 7.0')
gem 'rails', rails_version

# Extract the minimum Rails version from the version requirement.
# For example, a requirement of "~> 7.0" translates to ">= 7.0" and "< 8.0".
rails_req = Gem::Requirement.new(rails_version)
# Find the minimum version specified by a ">=" constraint, if any.
min_rails_version = rails_req.requirements.find { |op, _| op == '>=' }&.last || Gem::Version.new('0')

# Determine the sqlite3 version based on the minimum Rails version.
# If the minimum Rails version is less than 7.2, use "~> 1.4"; otherwise, use "~> 2.0".
sqlite_version =
  if min_rails_version < Gem::Version.new('7.2')
    "~> 1.4"
  else
    "~> 2.0"
  end

case ENV.fetch('DB', nil)
when 'mysql'
  gem 'mysql2'
when 'postgresql'
  gem 'pg'
else
  gem 'sqlite3', sqlite_version
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
