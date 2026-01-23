class Team < ApplicationRecord
  has_many :team_invitations, dependent: :destroy
  has_many :users, dependent: :nullify

  validates :name, presence: true, uniqueness: true

  scope :default_order, -> { order(:id) }
end
