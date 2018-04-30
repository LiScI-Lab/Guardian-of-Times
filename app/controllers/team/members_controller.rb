# coding: utf-8
class Team::MembersController < ApplicationController
  layout 'team'

  load_and_authorize_resource :team
  load_and_authorize_resource :member, through: :team

  def index
    @members = @team.members
  end

  def show
    redirect_to dashboard_team_member_path(@team, @member)
  end

  def dashboard
    # values = @member.progresses.group_by_month(:start)
    #            .map { |progresses|
    #   {name: progresses.first.start.month, data: progresses.map { |p| p.end-p.start }.sum}
    # }
    @values = @member.progresses
                .group_by{ |p| p.start.month }
                .sort_by{ |k,v| k }
                .map{ |k,v| ["#{k} #{v.first.start.year}", v.map{ |p| p.time_spend }.sum / 3600] }
    puts "values for diagram:", @values
  end

  def new
  end

  def edit
  end

  def update
    if @member.update member_params
      flash[:success] = "Member successfully updated"
      redirect_to dashboard_team_member_path(@team, @member)
    else
      flash[:error] = "Member not updated"
      render 'edit'
    end
  end

  def invite
    invite_params[:users].reject { |c| c.empty? }.each do |id|
      @team.members.find_or_initialize_by user: User.find(id)
    end
    if @team.save
      flash[:success] = "Users are invited!"
    else
      flash[:error] = "Something went wrong"
    end
    redirect_to team_members_path(@team)
  end

  def restore
    if @member.joined!
      flash[:success] = "Member is rejoined!"
    else
      flash[:error] = "Something went wrong"
    end
    redirect_to team_members_path(@team)
  end

  def destroy
    if @member.removed!
      flash[:success] = "Member is removed!"
    else
      flash[:error] = "Something went wrong"
    end
    redirect_to team_members_path(@team)
  end

  private
  def member_params
    params.require(:member).permit(:id, target_hours_attributes: [
        :id, :since, :hours
    ])
  end

  def invite_params
    params.require(:invitations).permit(users: [])
  end
end
