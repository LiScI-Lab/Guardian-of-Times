class Team::ProgressesController < SecurityController
  include ::ProgressFilter
  layout 'team'

  load_and_authorize_resource :team
  load_and_authorize_resource :progress, through: :team

  def index
    @progresses = get_filtered_progresses(@team)
  end
end
