class TagAffected < ApplicationRecord
  belongs_to :tag, class_name: "Tag"
  belongs_to :affected, polymorphic: true

  validates :affected, uniqueness: {scope: :tag}
end