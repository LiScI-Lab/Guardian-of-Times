class Tag < ApplicationRecord
  validates :name, presence: true, length: { minimum: Settings.tag.name.length_minimum }
  validates :description, allow_blank: true, length: { minimum: Settings.tag.description.length_minimum }
end
