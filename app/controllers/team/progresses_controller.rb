class Team::ProgressesController < ApplicationController
  layout 'team'

  load_and_authorize_resource :team
  load_and_authorize_resource :progress, through: :team

  def index
    @progresses = @team.progresses
  end
end
