class CreateUserApiTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :user_api_tokens do |t|
      t.belongs_to :user, foreign_key: true

      t.long :id
      t.string :token

      t.timestamps
    end
  end
end
