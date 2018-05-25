class AddAccessToTeam < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :access, :integer, null: false, default: 0
  end
end
