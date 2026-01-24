FactoryBot.define do
  factory :team_invitation do
    team
    sequence(:email) { "user#{_1}@example.com" }
    token { 'a * 32' }
    expires_at { 3.days.from_now }
    accepted_at { nil }
  end
end
