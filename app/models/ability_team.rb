module AbilityTeam
  include CanCan::Ability

  def initialize_team(user, member)
    alias_action :upload, to: :import

    can [:index, :invited, :owner], Team
    can [:create, :new], Team

    if member
      can [:show],                        Team, members: {id: member.id, status: Team::Member.statuses[:joined]}
      can [:dashboard, :update, :invite], Team, members: {id: member.id, role: Team::Member.roles[:owner]}
      can [:join],                        Team, members: {id: member.id, status: Team::Member.statuses[:invited]}
      # can [:index],  :sub_team do
      #   member.team.is_root? and ((member.joined? and member.team.has_children?) or member.owner?)
      # end

      # can [:create], :sub_team do
      #   member.owner? and member.team.is_root?
      # end

      can [:index],                                                         Team::Member, team: {members: {id: member.id, role: Team::Member.roles[:owner]}}
      can [:show, :dashboard, :update],                                     Team::Member, id: member.id
      can [:show, :dashboard, :update, :new, :invite, :destroy, :restore],  Team::Member, team: {members: {id: member.id, role: Team::Member.roles[:owner]}}

      cannot [:restore],                                                    Team::Member do |member|
        not member.removed?
      end
      cannot [:destroy],                                                    Team::Member do |member|
        not member.joined?
      end

      can [:index, :show, :export],             Team::Progress,           team: {members: {id: member.id, role: Team::Member.roles[:owner]}}
      can [:create, :start, :import, :export],  Team::Progress,           member: member
      can [:update, :stop],                     Team::Progress,           member: member
      can [:destroy],                           Team::Progress.kept,      member: member
      can [:restore],                           Team::Progress.discarded, member: member

      can [:create, :index], :export
    end
  end
end
