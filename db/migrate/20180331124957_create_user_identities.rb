class CreateUserIdentities < ActiveRecord::Migration[5.1]
  def change
    create_table :user_identities do |t|
      t.belongs_to :user, foreign_key: true

      t.string :provider
      t.string :uid
      t.string :token
      t.string :secret
      t.string :profile_page
      t.string :avatar_url

      t.timestamps

      t.datetime :discarded_at, index: true

      t.index [:user_id, :provider], unique: true
    end
  end
end
