class CreateTeam < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.string :name, index: true

      t.text :description

      t.string :ancestry, index: true

      t.timestamps null: false
      t.datetime :discarded_at, index: true

      t.index [:name, :ancestry], unique: true
    end
  end
end
