# frozen_string_literal: true

require "sinatra/base"
require "sinatra/activerecord"
require "erb"

require_relative "./config/environments" # database configuration

# Application Entry Point
class App < Sinatra::Base
  configure do
    set :public_folder, "public"
    set :views, "app/views"
  end
  get "/search" do
    erb :index
  end
end
