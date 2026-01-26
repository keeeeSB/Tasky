class Task < ApplicationRecord
  belongs_to :team

  validates :title, presence: true
  validates :description, presence: true, length: { maximum: 255 }
  validates :completed, presence: true, inclusion: { in: [true, false] }
end
