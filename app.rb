require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/url_for'
require 'active_support/core_ext'
require 'active_support/inflector'
# require_relative 'lib/minify_resources'

class SimpleCDNServer < Sinatra::Application

  configure :production do
    set :server, :puma
  end

  configure :development do
    set :server, :shotgun
  end

  configure do
    enable :sessions
    set :session_secret, 'fsmufgdsgf34234sifgdofjg'

    enable :logging

    set :views,         Dir["./views/"]
    set :public_folder, Proc.new { File.join(root, "public") }
    layout :layout

    ActiveRecord::Base.establish_connection(
      :adapter  => 'sqlite3',
      :database => 'db/sqlite3.db'
    )
  end

  # configure :production do
  #   set :haml, { :ugly => true }
  #   set :clean_trace, true
  #   set :css_files, :blob
  #   set :js_files,  :blob
  #   MinifyResources.minify_all
  # end

  # configure :development do
  #   set :css_files, MinifyResources::CSS_FILES
  #   set :js_files,  MinifyResources::JS_FILES
  # end

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
  end

  Dir["./models/*.rb"].each      { |file| require file }


  # Index
  get '/' do
    # protected!

    # Access.create(identifier: 'ohohoh')

    @accesses = Access.all
    erb :'accesses/index'
  end

  # New
  get '/accesses/new' do
    # protected!

    @access = Access.new
    erb :'accesses/new'
  end

  # Create
  post '/accesses' do
    # protected!

    @access = Access.create(params[:access])

    if @access.save
      redirect '/'
    else
      erb :'accesses/new'
    end
  end

  # New
  get '/accesses/edit/:id' do
    # protected!

    @access = Access.find(params[:id])
    erb :'accesses/edit'
  end

  # Create
  put '/accesses/:id' do
    # protected!

    @access = Access.find(params[:id])

    if @access.update(params[:access])
      redirect '/'
    else
      erb :'accesses/edit'
    end
  end

  # Show
  get '/accesses/:id' do
    # protected!

    @access = Access.find(params[:id])
    erb :'accesses/show'
  end

  # logger.info "loading data"
  run! if app_file == $0
end
