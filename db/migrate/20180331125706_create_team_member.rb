class CreateTeamMember < ActiveRecord::Migration[5.1]
  def change
    create_table :team_members do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :team, null: false, foreign_key: true

      t.integer :status, null: false, default: 0
      t.integer :role, null: false, default: 0

      t.timestamps null: false
      t.datetime :discarded_at, index: true

      t.index [:user_id, :team_id], unique: true
    end
  end
end
