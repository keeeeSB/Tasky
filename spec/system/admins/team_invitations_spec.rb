require 'rails_helper'

RSpec.describe 'チーム招待機能', type: :system do
  let(:admin) { create(:admin) }
  let!(:team) { create(:team, name: 'バックエンドーズ') }

  describe 'チーム招待' do
    it '管理者は、ユーザーをチームに招待できる' do
      login_as admin, scope: :admin
      visit admins_team_path(team)

      expect(page).to have_selector 'h2', text: 'チーム詳細'
      expect(page).to have_content 'バックエンドーズ'
      click_link 'チームへ招待する'

      expect(page).to have_current_path new_admins_team_team_invitation_path(team)
      expect(page).to have_selector 'h2', text: 'チーム招待'

      fill_in '招待者メールアドレス', with: 'alice@example.com'
      expect {
        click_button '招待する'
        expect(page).to have_content 'チーム招待メールを送信しました。'
        expect(page).to have_current_path admins_team_path(team)
      }.to change(TeamInvitation, :count).by(1)

      email = open_last_email

      expect(email.subject).to eq 'チーム招待のお知らせ'
    end
  end
end
