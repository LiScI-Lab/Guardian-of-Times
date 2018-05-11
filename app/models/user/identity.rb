class User::Identity < ApplicationRecord
  belongs_to :user

  validates :user, uniqueness: {scope: :provider}
end