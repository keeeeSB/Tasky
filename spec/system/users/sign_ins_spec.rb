require 'rails_helper'

RSpec.describe 'ユーザーログイン機能', type: :system do
  let!(:user) { create(:user, name: 'アリス', email: 'alice@example.com', password: 'password12345', confirmed_at: Time.current) }

  describe 'ユーザーログイン' do
    context 'アカウント承認済みのユーザーの場合' do
      it 'ログインできる' do
        visit new_user_session_path
        expect(page).to have_selector 'h2', text: 'ログイン'

        fill_in 'メールアドレス', with: 'alice@example.com'
        fill_in 'パスワード', with: 'password12345'
        click_button 'ログインする'

        expect(page).to have_content 'ログインしました。'
        expect(page).to have_current_path root_path
      end
    end

    context 'アカウント未承認のユーザーの場合' do
      before do
        user.update!(confirmed_at: nil)
        user.send_confirmation_instructions
      end

      it 'アカウント承認後、ログインできる' do
        visit new_user_session_path
        expect(page).to have_selector 'h2', text: 'ログイン'

        fill_in 'メールアドレス', with: 'alice@example.com'
        fill_in 'パスワード', with: 'password12345'
        click_button 'ログインする'

        expect(page).to have_content 'メールアドレスの本人確認が必要です。'

        email = open_last_email
        expect(email.subject).to eq 'メールアドレス確認メール'

        click_first_link_in_email(email)

        expect(page).to have_content 'メールアドレスが確認できました。'
        expect(page).to have_current_path new_user_session_path

        fill_in 'メールアドレス', with: 'alice@example.com'
        fill_in 'パスワード', with: 'password12345'
        click_button 'ログインする'

        expect(page).to have_content 'ログインしました。'
        expect(page).to have_current_path root_path
      end
    end
  end

  describe 'ユーザーログアウト' do
    it 'ログイン中のユーザーは、ログアウトできる' do
      login_as user, scope: :user
      visit root_path

      expect(page).to have_content 'アリス'
      expect(page).to have_button 'ログアウト'

      click_button 'ログアウト'
      expect(page).to have_content 'ログアウトしました。'
      expect(page).to have_current_path root_path
    end
  end
end
