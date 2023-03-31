# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/activerecord'

require_relative './config/environments' # database configuration

# Application Entry Point
class App < Sinatra::Base
  get '/search' do
  end
end
