# coding: utf-8
class Team::MembersController < ApplicationController
  include DateTimeHelper
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
    if @member.role.to_sym == :owner
      @time_spend_hours = @team.members.map { |m|
        { name: m.user.realname, data: time_spend_series(m) }
      }

      spend_hours = @team.members.map { |m|
        [m.user.realname, seconds_to_hours(m.current_month_time_spend)]
      }
      target_hours = @team.members.map { |m|
        [m.user.realname, m.recent_target_hours]
      }

      @time_spend_with_target_hours = [
        {name: "Time spend", data: spend_hours},
        {name: "Time Vertrag", data: target_hours}
      ]
      # raise 'dump'
    else
      @time_spend_hours = time_spend_series(@member)
      @time_spend_with_target_hours = time_spend_with_target_hours(@member)
    end
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

  def time_spend_series(member)
    member.progresses.kept
      .group_by{ |p| p.start.month }
      .sort_by { |k,v| k }
      .map{ |k,v| ["#{Date::MONTHNAMES[k]} #{v.first.start.year}", seconds_to_hours(v.map{ |p| p.time_spend }.sum)] }
  end

  def time_spend_with_target_hours(member)
    time_spend_label = "Time spend"
    time_vertrag_label = "Time Vertrag"
    data_label = member.user.realname
    time_spend = seconds_to_hours(member.progresses.kept.in_month(DateTime.now).map(&:time_spend).sum)
    target_hours = member.target_hours.last.hours if member.target_hours.last

    [
      {name: time_spend_label, data: {data_label => time_spend}},
      {name: time_vertrag_label, data: {data_label => (target_hours || 0)}}
    ]
  end


end
