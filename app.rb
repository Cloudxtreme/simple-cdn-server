require 'rubygems'
require 'sinatra'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => 'db/sqlite3.db'
)

class SimpleCDNServer < Sinatra::Application
  enable :sessions

  set :views, ['views/layouts', 'views/pages', 'views/partials']
end
