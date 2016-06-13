require 'test_helper'

class ApiKeyAuthTest < ActionDispatch::IntegrationTest

  def test_authentication_failure
    assert_raises(RestClient::Unauthorized) do
      RestClient.get 'http://localhost:3000/auth.json', {:api_key => 'test'}
    end
  end

  def test_authentication_success
    res = RestClient.get 'http://localhost:3000/auth.json', {:api_key => 'IOS-3kHudwmH'}
    assert res.headers.key? :api_session_key
  end

  def test_access_resource_without_session_key
    assert_raises(RestClient::Unauthorized) do
      RestClient.get 'http://localhost:3000/projects.json'
    end
  end

  def test_access_resource_with_invalid_session_key
    assert_raises(RestClient::Unauthorized) do
      RestClient.get 'http://localhost:3000/projects.json', {:api_session_key => 'cT0febFoD5lxAlo6g'}
    end
  end

  def test_access_resource_with_valid_session_key
    res = RestClient.get 'http://localhost:3000/auth.json', {:api_key => 'IOS-3kHudwmH'}
    api_session_key = res.headers[:api_session_key]

    res = RestClient.get 'http://localhost:3000/projects.json', {:api_session_key => api_session_key}
    assert_equal 200, res.code
  end
end
