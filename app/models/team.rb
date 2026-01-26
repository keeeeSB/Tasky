class Team < ApplicationRecord
  has_one_attached :logo do |attachable|
    attachable.variant :thumb, resize_to_fill: [100, 100]
    attachable.variant :logo, resize_to_fill: [20, 20]
  end

  has_many :team_invitations, dependent: :destroy
  has_many :users, dependent: :nullify
  has_many :tasks, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  scope :default_order, -> { order(:id) }
end
