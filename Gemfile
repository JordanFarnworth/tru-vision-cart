source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.2'
gem 'pg'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.5'
gem 'sprockets-rails', '~> 3.0', '>= 3.0.4'
gem 'bootstrap', git: 'https://github.com/twbs/bootstrap-rubygem'
gem 'addressable'
gem 'font-awesome-sass', '~> 4.7.0'
gem 'sweetalert-rails'
gem 'lodash-rails'
gem 'bootstrap_form'
gem 'card-js-rails', '~> 1.0'
gem 'delayed_job_active_record'
gem 'sendgrid-ruby'

gem 'sprockets-es6'
gem 'babel-transpiler', git: 'https://github.com/babel/ruby-babel-transpiler'

group :development, :test do
  gem 'byebug', platform: :mri
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'mailcatcher'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "roo", "~> 2.7.0"
