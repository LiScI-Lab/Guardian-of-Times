class Api::Team::ProgressesController
  include ::ProgressFilter

  load_and_authorize_resource :team
  load_and_authorize_resource :progress, through: :team

  def index
    @progresses = get_filtered_progresses(@team)
    render json: @progresses.to_json
  end
end
