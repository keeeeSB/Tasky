class Team < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  scope :default_order, -> { order(:id) }
end
