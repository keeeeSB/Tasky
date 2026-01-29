require 'rails_helper'

RSpec.describe 'タスク機能', type: :system do
  let!(:team) { create(:team, name: 'バックエンドーズ') }
  let(:user) { create(:user, team:) }
  let!(:task) { create(:task, team:, title: 'ログイン機能を実装する', description: 'Deviseを使用し、ログイン機能を実装する。', completed: false) }

  describe 'タスク一覧' do
    it 'ログイン中のユーザーは、タスクの一覧を閲覧できる' do
      login_as user, scope: :user
      visit users_team_path

      expect(page).to have_selector 'h2', text: 'バックエンドーズ'
      expect(page).to have_selector 'h4', text: 'タスク一覧'
      within first('.card') do
        expect(page).to have_content 'ログイン機能を実装する'
        expect(page).to have_content 'Deviseを使用し、ログイン機能を実装する。'
      end
    end
  end

  describe 'タスク詳細' do
    it 'ログイン中のユーザーは、タスクの詳細を閲覧できる' do
      login_as user, scope: :user
      visit users_team_path

      expect(page).to have_selector 'h2', text: 'バックエンドーズ'
      expect(page).to have_selector 'h4', text: 'タスク一覧'
      first('.card').click

      expect(page).to have_selector 'h2', text: 'タスク詳細'
      expect(page).to have_content 'ログイン機能を実装する'
      expect(page).to have_content 'Deviseを使用し、ログイン機能を実装する。'
    end
  end

  describe 'タスク作成' do
    it 'ログイン中のユーザーは、タスクを作成できる' do
      login_as user, scope: :user
      visit users_team_path

      expect(page).to have_selector 'h2', text: 'バックエンドーズ'

      click_link 'タスクを作成する'

      expect(page).to have_current_path new_users_team_task_path
      expect(page).to have_selector 'h2', text: 'タスク作成'

      fill_in 'タイトル', with: 'タスク機能を実装する'
      fill_in '説明文', with: 'ユーザーがタスクを作成できるようにする。'
      expect {
        click_button '登録する'
        expect(page).to have_content 'タスクを作成しました。'
        expect(page).to have_current_path users_team_task_path(Task.last)
      }.to change(Task, :count).by(1)

      expect(page).to have_selector 'h2', text: 'タスク詳細'
      expect(page).to have_content 'タスク機能を実装する'
      expect(page).to have_content 'ユーザーがタスクを作成できるようにする。'
    end
  end

  describe 'タスク削除' do
    it 'ログイン中のユーザーは、タスクを削除できる' do
      login_as user, scope: :user
      visit users_team_task_path(task)

      expect(page).to have_selector 'h2', text: 'タスク詳細'
      expect(page).to have_content 'ログイン機能を実装する'
      expect(page).to have_content 'Deviseを使用し、ログイン機能を実装する。'

      expect {
        accept_confirm do
          click_button '削除する'
        end
        expect(page).to have_content 'タスクを削除しました。'
        expect(page).to have_current_path users_team_path
      }.to change(Task, :count).by(-1)

      expect(page).to have_selector 'h2', text: 'バックエンドーズ'
      expect(page).to have_selector 'h4', text: 'タスク一覧'
      expect(page).to have_content 'タスクがありません。'
      expect(page).not_to have_content 'ログイン機能を実装する'
    end
  end
end
