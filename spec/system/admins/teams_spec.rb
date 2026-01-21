require 'rails_helper'

RSpec.describe 'チーム機能', type: :system do
  let(:admin) { create(:admin) }
  let!(:team) { create(:team, name: 'バックエンドーズ') }

  describe 'チーム一覧' do
    it '管理者は、チームの一覧を閲覧できる' do
      login_as admin, scope: :admin
      visit admins_root_path

      click_link 'チーム一覧'
      expect(page).to have_current_path admins_teams_path

      expect(page).to have_selector 'h2', text: 'チーム一覧'
      within('tr', text: 'バックエンドーズ') do
        expect(page).to have_content 'バックエンドーズ'
      end
    end
  end

  describe 'チーム詳細' do
    it '管理者は、チームの詳細を閲覧できる' do
      login_as admin, scope: :admin
      visit admins_root_path

      click_link 'チーム一覧'
      expect(page).to have_current_path admins_teams_path

      within('tr', text: 'バックエンドーズ') do
        expect(page).to have_content 'バックエンドーズ'
        click_link '詳細'
      end

      expect(page).to have_current_path admins_team_path(team)
      expect(page).to have_selector 'h2', text: 'チーム詳細'
      expect(page).to have_content 'バックエンドーズ'
    end
  end

  describe 'チーム作成' do
    it '管理者は、チームを作成できる' do
      login_as admin, scope: :admin
      visit admins_teams_path

      click_link 'チームを追加'
      expect(page).to have_current_path new_admins_team_path

      expect(page).to have_selector 'h2', text: 'チーム作成'

      fill_in 'チーム名', with: 'フロントエンドーズ'
      expect {
        click_button '登録する'
        expect(page).to have_content 'チームを作成しました。'
        expect(page).to have_current_path admins_team_path(Team.last)
      }.to change(Team, :count).by(1)

      expect(page).to have_selector 'h2', text: 'チーム詳細'
      expect(page).to have_content 'フロントエンドーズ'
    end
  end

  describe 'チーム編集' do
    it '管理者は、チーム情報を編集できる' do
      login_as admin, scope: :admin
      visit admins_team_path(team)

      expect(page).to have_selector 'h2', text: 'チーム詳細'
      expect(page).to have_content 'バックエンドーズ'

      click_link '編集する'
      expect(page).to have_current_path edit_admins_team_path(team)

      fill_in 'チーム名', with: 'データベースズ'
      click_button '更新する'

      expect(page).to have_content 'チーム情報を更新しました。'
      expect(page).to have_current_path admins_team_path(team)
      expect(page).to have_content 'データベースズ'
    end
  end

  describe 'チーム削除' do
    it '管理者は、チームを削除できる' do
      login_as admin, scope: :admin
      visit admins_team_path(team)

      expect(page).to have_selector 'h2', text: 'チーム詳細'
      expect(page).to have_content 'バックエンドーズ'

      expect {
        accept_confirm do
          click_button '削除する'
        end
        expect(page).to have_content 'チームを削除しました。'
        expect(page).to have_current_path admins_teams_path
      }.to change(Team, :count).by(-1)
    end
  end
end
