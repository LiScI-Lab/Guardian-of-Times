class Api::TeamsController < Api::SecuredApiController

  load_and_authorize_resource
  def index
    @teams = Team.visible(@current_user)
    render json: @teams.to_json
  end

  def involved
    @teams = @current_user.involved_teams.kept
    render json: @teams.to_json
  end

  def invited
    @teams = @current_user.invited_teams.kept
    render json: @teams.to_json
  end

  def requested
    @teams = @current_user.requested_teams.kept
    render json: @teams.to_json
  end

  def owner
    @teams = @current_user.own_teams.kept
    render json: @teams.to_json
  end

  def invite
    #TODO: Test!
    @user = User.find params[:user_id]
    member = @team.members.find_or_initialize_by user: @user
    member.discarded_at = nil
    if member.save
      @message = "#{@user.name} successfully invited"
      @status = 200
    else
      @message = "Something went wrong"
      @status = 500
    end
    render json: @message.to_json, status: @status
  end

  def ask
    #TODO: Test!
    member = @team.members.find_or_initialize_by user: @current_user
    if member.requested!
      @message = "Access requested!"
      @status = 200
    else
      @message = "Something went wrong"
      @status = 500
    end
    render json: @message.to_json, status: @status
  end

  def revoke
    #TODO: Test!
    member = @team.members.find_or_initialize_by user: @current_user
    if member.revoked!
      @message = "Request revoked!"
      @status = 200
    else
      @message =  "Something went wrong"
      @status = 500
    end
    render json: @message.to_json, status: @status
  end

  def join
    #TODO: Test!
    unless @current_member
      @current_member = @team.members.new user: @current_user
    end
    @current_member.status = :joined
    if @current_member.save
      @message = "Successfully joined #{@team.name}"
      @status = 200
    else
      @message =  "Something went wrong"
      @status = 500
    end
    render json: @message.to_json, status: @status
  end

  def show
    #TODO: Send more detailed Version of team informations. E.g. Send members
    if can? :show, @team
      render json: @team.to_json
    end
  end

  def dashboard
    #TODO: Implement
  end

  def create
    #TODO: Test!
    @team.members.new user: @current_user, role: :owner
    if @team.save
      @message = "Team successfully created"
      @status = 200
    else
      @message =  "Something went wrong"
      @status = 500
    end
    render json: @message.to_json, status: @status
  end

  def update
    #TODO: Test!
    if @team.update team_params
      @message = "Team successfully updated"
      @status = 200
    else
      @message =  "Something went wrong"
      @status = 500
    end
    render json: @message.to_json, status: @status
  end

  def destoy
    #TODO: Implement, but not very soon!
    # Team deletion is generally not supported by the TimeTracker by now!
  end

  private
  def team_params
    p = params.require(:team).permit([:name, :description, :access, :tag_list, :own_tag_list])
    if p[:own_tag_list].present?
      p[:own_tag_list] = {owner: @current_member, tag_list: p[:own_tag_list]}
    end
    p
  end
end
