class ProjectsController < ApplicationController
  before_filter :validate_api_session_key

  def index
    render json: Project.all
  end


  def create
    @project = Project.new(json_body)
    if @project.save
      render json: @project
    else
       render nothing: true, status: :bad_request
    end
  end

  private

  def json_body
    JSON.parse(request.body.read)
  end

  def validate_api_session_key
    # prepend HTTP_ here: http://stackoverflow.com/questions/2311883/authorization-header-in-ruby-on-rails-accessed-with-key-http-authorization-inste
    session_key = request.headers['HTTP_API_SESSION_KEY']
    if Rails.cache.read(session_key).nil?
      render nothing: true, status: :unauthorized
    end
  end
end
