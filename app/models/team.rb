class Team < ApplicationRecord
  has_many :team_invitations, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  scope :default_order, -> { order(:id) }
end
