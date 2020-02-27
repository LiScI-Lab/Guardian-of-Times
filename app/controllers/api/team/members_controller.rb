class Api::Team::MembersController
  include DateTimeHelper

  oad_and_authorize_resource :team
  load_and_authorize_resource :member, through: :team

  def index
  end

  def outstanding
  end

  def show
  end

  def dashboard
  end

  def accept
  end

  def update
  end

  def restore
  end

  def destroy
  end

  def change_role
  end

  private
  def member_params
    p = params.require(:member).permit(:id, :tag_list, :own_tag_list, :show_online_status, :show_tracking_status, target_hours_attributes: [
        :id, :since, :hours
    ])
    if p[:own_tag_list].present?
      p[:own_tag_list] = {owner: @current_member, tag_list: p[:own_tag_list]}
    end
    p
  end
end
