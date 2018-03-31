class CreateProjectMember < ActiveRecord::Migration[5.1]
  def change
    create_table :project_members do |t|
      t.integer :role, null: false, default: 0
    end
  end
end
