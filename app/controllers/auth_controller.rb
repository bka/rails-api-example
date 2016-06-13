class AuthController < ApplicationController
  def index
    begin
      response.headers["API_SESSION_KEY"] = session_for_api_key(request.headers['HTTP_API_KEY'])
      render nothing: true, status: :ok
    rescue Errors::AuthenticationError => e
      render nothing: true, status: :unauthorized
    end
  end

  def session_for_api_key api_key
    if api_key == "IOS-3kHudwmH"
      session_key = SecureRandom.urlsafe_base64(nil, false)
      Rails.cache.write(session_key, "123", expires_in: 1.minutes)
      return session_key
      # return Rails.cache.write(session_key, Time.now)
      # Rails.cache.fetch("#{session_key}", expires_in: 1.minutes) do
      #   Time.now.to_i.to_s
      # end
      # return session_key
    end
    raise Errors::AuthenticationError
  end
end
