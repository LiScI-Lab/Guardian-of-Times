class CreateTagAffected < ActiveRecord::Migration[5.1]
  def change
    create_table :tag_affecteds do |t|
      t.belongs_to :tags
      t.belongs_to :affected, polymorphic: true
    end
  end
end
