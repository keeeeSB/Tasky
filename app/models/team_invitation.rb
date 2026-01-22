class TeamInvitation < ApplicationRecord
  belongs_to :team

  before_validation :set_token, :set_expires_at, on: :create

  validates :email, presence: true
  validates :token, presence: true, uniqueness: true
  validates :expires_at, presence: true

  private

  def set_token
    self.token ||= SecureRandom.urlsafe_base64(32)
  end

  def set_expires_at
    self.expires_at ||= 1.day.from_now
  end
end
