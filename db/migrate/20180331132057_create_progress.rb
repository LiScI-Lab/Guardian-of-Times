class CreateProgress < ActiveRecord::Migration[5.1]
  def change
    create_table :progresses do |t|
      t.datetime :start
      t.datetime :end
      t.string :description
    end
  end
end
