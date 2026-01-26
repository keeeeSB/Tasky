FactoryBot.define do
  factory :task do
    team
    title { '議事録を作成する' }
    description { '本日のミーティング内容をまとめて、Slack に共有する。' }
    completed { false }
  end
end
