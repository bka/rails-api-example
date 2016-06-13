module ApiKeyAuthentication
  extend ActiveSupport::Concern

  def authenticate_by_api_key
    begin
      response.headers["API_SESSION_KEY"] = session_for_api_key(request.headers['HTTP_API_KEY'])
      render nothing: true, status: :ok
    rescue Errors::AuthenticationError => e
      render nothing: true, status: :unauthorized
    end
  end

  def session_for_api_key api_key
    if Rails.configuration.api_keys.member? api_key
      session_key = SecureRandom.urlsafe_base64(nil, false)
      Rails.cache.write(session_key, session_key, expires_in: 1.minutes)
      return session_key
    end
    raise Errors::AuthenticationError
  end

  def validate_api_session_key
    # prepend HTTP_
    # see http://stackoverflow.com/questions/2311883/authorization-header-in-ruby-on-rails-accessed-with-key-http-authorization-inste
    session_key = request.headers['HTTP_API_SESSION_KEY']
    if Rails.cache.read(session_key).nil?
      render nothing: true, status: :unauthorized
    end
  end
end
