require 'rails_helper'

RSpec.describe 'ユーザー機能', type: :system do
  let(:admin) { create(:admin) }
  let(:team) { create(:team, name: 'バックエンドーズ') }
  let!(:user) { create(:user, name: 'アリス', email: 'alice@example.com', created_at: Date.new(2026, 1, 1), team:) }

  describe 'ユーザー一覧' do
    it '管理者は、ユーザーの一覧を閲覧できる' do
      login_as admin, scope: :admin
      visit admins_root_path

      click_link 'ユーザー一覧'
      expect(page).to have_current_path admins_users_path

      expect(page).to have_selector 'h2', text: 'ユーザー一覧'
      within('tr', text: 'アリス') do
        expect(page).to have_content 'アリス'
        expect(page).to have_content 'alice@example.com'
        expect(page).to have_content '2026年01月01日'
      end
    end
  end

  describe 'ユーザー詳細' do
    it '管理者は、ユーザーの詳細を閲覧できる' do
      login_as admin, scope: :admin
      visit admins_users_path

      expect(page).to have_selector 'h2', text: 'ユーザー一覧'
      within('tr', text: 'アリス') do
        click_link '詳細'
      end
      expect(page).to have_current_path admins_user_path(user)

      expect(page).to have_content 'アリス'
      expect(page).to have_content 'alice@example.com'
      expect(page).to have_content '2026年01月01日'
      expect(page).to have_content 'バックエンドーズ'
    end
  end
end
