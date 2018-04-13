class CreateJoinTableTeamMemberTeamProgress < ActiveRecord::Migration[5.1]
  def change
    create_join_table :team_members, :team_progresses do |t|
      t.timestamps null: false
      t.datetime :discarded_at, index: true

      t.index [:team_member_id, :team_progress_id], unique: true, name: 'index_team_members_progresses_member_id_progress_id'
      t.index [:team_progress_id, :team_member_id], unique: true, name: 'index_team_members_progresses_progress_id_member_id'
    end
  end
end
