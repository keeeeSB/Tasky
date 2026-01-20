class Admins::TeamsController < Admins::ApplicationController
  before_action set_team, only: %i[show edit update destroy]

  def index
    @teams = Team.default_order.page(params[:page])
  end

  def show
  end

  def new
    @team = Team.new
  end

  def edit
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      redirect_to admins_team_path(@team), notice: 'チームを作成しました。'
    else
      flash.now[:alert] = 'チームを作成できませんでした。'
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @team.update(team_params)
      redirect_to admins_team_path(@team), notice: 'チーム情報を更新しました。'
    else
      flash.now[:alert] = 'チーム情報を更新できませんでした。'
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @team.destroy!
    redirect_to admins_teams_path, notice: 'チームを削除しました。', status: :see_other
  end

  private

  def team_params
    params.expect(team: %i[name])
  end

  def set_team
    @tean = Team.find(params[:id])
  end
end
