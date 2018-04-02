class CreateProjectMember < ActiveRecord::Migration[5.1]
  def change
    create_table :project_members do |t|
      t.belongs_to :user, index: true
      t.belongs_to :project, index: true

      t.integer :status, null: false, default: 0
      t.integer :role, null: false, default: 0

      t.timestamps null: false
      t.datetime :discarded_at, index: true

      t.index [:user_id, :project_id], unique: true
    end
  end
end
