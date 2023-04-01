# frozen_string_literal: true

require "sinatra/base"
require "sinatra/activerecord"
require "erb"

require_relative "./config/environments" # database configuration

current_dir = Dir.pwd

# ./models/
Dir["#{current_dir}/app/models/*.rb"].sort.each { |file| require_relative file }

# Application Entry Point
class App < Sinatra::Base
  configure do
    set :public_folder, "public"
    set :views, "app/views"
  end
  get "/" do
    erb :index
  end
  get "/search" do
    @areas = Area.search(params)
    @areas.to_json
    erb :schedules
  end
end
