class Task < ApplicationRecord
  belongs_to :team

  validates :title, presence: true
  validates :description, presence: true, length: { maximum: 255 }
  validates :completed, inclusion: { in: [true, false] }

  scope :default_order, -> { order(created_at: :desc, id: :desc) }
end
