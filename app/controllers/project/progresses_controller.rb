class Project::ProgressesController < ApplicationController
  layout 'project'

  load_and_authorize_resource :project
  load_and_authorize_resource :progress, through: :project

  def index
  end
end
