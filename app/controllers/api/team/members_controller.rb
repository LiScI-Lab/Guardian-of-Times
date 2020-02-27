class Api::Team::MembersController < Api::SecuredApiController
  include DateTimeHelper

  load_and_authorize_resource :team
  load_and_authorize_resource :member, through: :team

  def index
    @members = @team.members
  end

  def outstanding
    @members = @team.members.where(status: :requested)
  end

  def show
    #TODO: Implement
  end

  def dashboard
    #TODO: Implement
  end

  def accept
    if @member.joined!
      @message = "Member joined successfully!"
      @status = 200
    else
      @message = "Something went wrong"
      @status = 500
    end
    render json: Hash["message:"  => @message].to_json, status: @status
  end

  def update
    if @member.update member_params
      @message = "Member successfully updated"
      @status = 200
    else
      @message = "Member not updated"
      @status = 500
    end
    render json: Hash["message:"  => @message].to_json, status: @status
  end

  def restore
    if @member.joined!
      @message = "Member has rejoined!"
      @status = 200
    else
      @message = "Something went wrong"
      @status = 500
    end
    render json: Hash["message:"  => @message].to_json, status: @status
  end

  def destroy
    if @member.joined?
      if @member.removed!
        @message = "Member was removed!"
        @status = 200
      else
        @message = "Something went wrong"
        @status = 500
      end
    else
      if @member.discard
        @message = "Member was removed!"
        @status = 200
      else
        @message = "Something went wrong"
        @status = 500
      end
    end
    render json: Hash["message:"  => @message].to_json, status: @status
  end

  def change_role
    role = params[:member][:role]

    if @member == @current_member
      @message = "You can not change your own role!"
      @status = 500
    elsif @member.role_greater_than? @current_member.role
      @message = "The other member has higher privileges than you!"
      @status = 500
    elsif @current_member.role_less_than? role
      @message = "You can not grant rights higher than your's"
      @status = 500
    elsif @member.role != role
      role_was = @member.role
      @member.role = role.to_sym
      if @member.save
        @message = "The role of #{@member.user.name} was set from #{role_was} to #{@member.role}."
        @status = 200
      else
        flash[:error] = 'Etwas ist beim speichern schief gegangen....'
        @message = "Something went wrong while saving..."
        @status = 500
      end
    end
    render json: Hash["message:"  => @message].to_json, status: @status
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
