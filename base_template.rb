# base_template.rb
load_template "/Users/netbe/code/bundler_template.rb"

project_dir = root.split('/').last

# Delete unnecessary files
run "rm README"
run "rm doc/README_FOR_APP"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/robots.txt"
run "rm -f public/javascripts/*"
run "rm db/*.sqlite3"

# Download JQuery
run "curl -L http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js > public/javascripts/jquery.js"

git :init

file ".gitignore", <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"


file 'Gemfile', <<-GEMFILE
source :gemcutter
gem 'rails', '3.0.5', :require => nil
# Switch to the appropriate gem for your database
gem 'mysql'
gem 'mongrel'
gem 'haml'
gem "haml-rails", ">= 0.3.4"


GEMFILE

# ===============================================================================
# = CONFIG FILES                                                                =
# ===============================================================================

file 'config/database.yml',
%{development:
  adapter: mysql
  encoding: utf8
  database: #{project_dir}
  user: root
  password: root
  pool: 5
  timeout: 5000

production:
  adapter: mysql
  encoding: utf8
  database: #{project_dir}_production
  username: #{project_dir}
  password: 

test: &TEST
  adapter: mysql
  encoding: utf8
  database: #{project_dir}_test
  user: root
  password: root
  pool: 5
  timeout: 5000

}

run "cp config/database.yml config/.database.yml"

git :add => ".", :commit => "-m 'initial commit'"


generate :controller, "welcome index"
route "root :to => 'welcome#index'"
git :rm => "public/index.html"

git :add => ".", :commit => "-m 'adding welcome controller'"