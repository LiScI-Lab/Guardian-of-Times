class CreateUserIdentities < ActiveRecord::Migration[5.1]
  def change
    create_table :user_identities do |t|
      t.belongs_to :user, foreign_key: true

      t.string :provider
      t.string :uid
      t.string :token
      t.string :secret
      t.string :profile_page

      t.timestamps

      t.datetime :discarded_at, index: true
    end
  end
end
