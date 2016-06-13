class AuthController < ApplicationController
  include ApiKeyAuthentication

  def index
    authenticate_by_api_key
  end
end
