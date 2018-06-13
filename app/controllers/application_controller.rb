class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: ENV['http_basic_auth_username'], password: ENV['http_basic_auth_password']
  protect_from_forgery with: :exception, unless: -> { request.format.json? }
end
