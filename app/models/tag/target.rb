class Tag::Target < ApplicationRecord
  belongs_to :tag, class_name: Tag.name
  belongs_to :member, class_name: Team::Member.name

  belongs_to :affected, polymorphic: true

  validates :affected, presence: true, uniqueness: {scope: [:tag, :member]}
  validates :tag, presence: true, uniqueness: {scope: [:tag, :member]}
  validates :member, presence: false, uniqueness: {scope: [:tag, :affected]}
end