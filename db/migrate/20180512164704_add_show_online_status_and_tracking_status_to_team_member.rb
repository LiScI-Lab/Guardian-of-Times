class AddShowOnlineStatusAndTrackingStatusToTeamMember < ActiveRecord::Migration[5.1]
  def change
    add_column :team_members, :show_online_status, :boolean, default: true
    add_column :team_members, :show_tracking_status, :boolean, default: true
  end
end
