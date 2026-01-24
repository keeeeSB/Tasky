require 'rails_helper'

RSpec.describe 'チーム招待機能', type: :system do
  describe 'チーム参加' do
    let!(:user) { create(:user, email: 'alice@example.com', password: 'password12345') }
    let!(:team) { create(:team, name: 'バックエンドーズ') }
    let(:invitation) { create(:team_invitation, team:, email: 'alice@example.com') }

    before do
      TeamInvitationMailer.invite(invitation).deliver_now
    end

    context 'ログイン中のユーザーの場合' do
      it '招待メール内のリンクをクリックすると、チームに参加できる' do
        login_as user, scope: :user

        email = open_last_email

        expect(email.subject).to eq 'チーム招待のお知らせ'

        click_first_link_in_email(email)

        expect(page).to have_content 'チームに参加しました。'
        expect(page).to have_current_path root_path
      end
    end

    context '未ログインのユーザーの場合' do
      it '招待メールないのリンクをクリックすると、ログイン後、チームに参加できる' do
        email = open_last_email

        expect(email.subject).to eq 'チーム招待のお知らせ'

        click_first_link_in_email(email)

        expect(page).to have_content 'ログインしてください。'
        expect(page).to have_current_path new_user_session_path

        fill_in 'メールアドレス', with: 'alice@example.com'
        fill_in 'パスワード', with: 'password12345'
        click_button 'ログインする'

        expect(page).to have_content 'チームに参加しました。'
        expect(page).to have_current_path root_path
      end
    end
  end
end
