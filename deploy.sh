#!/bin/bash
git checkout -b heroku-deploy
bundle exec rake assets:precompile RAILS_ENV=production
git add -A
git commit -m 'assets'
git push heroku HEAD:master -f
heroku run rake db:migrate
git checkout master
git branch -D heroku-deploy
echo "app deployed"
