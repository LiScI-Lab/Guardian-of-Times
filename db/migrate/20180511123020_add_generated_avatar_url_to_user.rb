class AddGeneratedAvatarUrlToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :generated_avatar_url, :string

    reversible do |direction|
      direction.up do
        User.all.each do |user|
          user.touch
          user.save
        end
      end
    end
  end
end
