class CreateTeamMemberTargetHour < ActiveRecord::Migration[5.1]
  def change
    create_table :team_member_target_hours do |t|
      t.belongs_to :team_member, foreign_key: true

      t.date :since, null: false
      t.integer :hours, null: false, default: 0

      t.timestamps null: false
      t.datetime :discarded_at, index: true
    end
  end
end
