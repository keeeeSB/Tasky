class TeamInvitation < ApplicationRecord
  belongs_to :team

  validates :email, presence: true
  validates :token, presence: true, uniqueness: true
  validates :expires_at, presence: true
  validates :accepted_at, presence: true
end
