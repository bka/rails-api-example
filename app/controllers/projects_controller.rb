class ProjectsController < ApplicationController
  include ApiKeyAuthentication
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
end
