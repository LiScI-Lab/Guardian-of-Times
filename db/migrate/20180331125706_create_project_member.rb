class CreateProjectMember < ActiveRecord::Migration[5.1]
  def change
    create_table :project_members do |t|
      t.integer :role, null: false, default: 0

      t.integer :target_hours, null: false, default: 0

      t.timestamps null: false
      t.datetime :discarded_at, index: true
    end
  end
end
