class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  belongs_to :team, optional: true

  validates :name, presence: true

  scope :default_order, -> { order(:id) }
end
