require 'rails_helper'

RSpec.describe '管理者ログイン', type: :system do
  let!(:admin) { create(:admin, email: 'admin@example.com', password: 'password12345') }

  describe '管理者ログイン' do
    it '管理者は、管理画面にログインできる' do
      visit new_admin_session_path
      expect(page).to have_selector 'h2', text: '管理者ログイン'

      fill_in 'メールアドレス', with: 'admin@example.com'
      fill_in 'パスワード', with: 'password12345'
      click_button 'ログインする'

      expect(page).to have_content 'ログインしました。'
      expect(page).to have_current_path admins_root_path
      expect(page).to have_selector 'h2', text: '管理者ホーム'
    end
  end

  describe '管理者ログアウト' do
    it 'ログイン中の管理者は、ログアウトできる' do
      login_as admin, scope: :admin
      visit admins_root_path

      expect(page).to have_selector 'h2', text: '管理者ホーム'
      find('.dropdown-toggle', text: '管理者').click
      click_button 'ログアウト'

      expect(page).to have_content 'ログアウトしました。'
      expect(page).to have_current_path new_admin_session_path
      expect(page).to have_selector 'h2', text: '管理者ログイン'
    end
  end
end
