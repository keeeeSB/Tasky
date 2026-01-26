class Users::Teams::TasksController < Users::ApplicationController
  before_action :set_team
  before_action :set_task, only: %i[show edit update destroy]

  def show
  end

  def new
    @task = @team.tasks.build
  end

  def edit
  end

  def create
    @task = @team.tasks.build(task_params)
    if @task.save
      redirect_to users_team_task_path(@task), notice: 'タスクを作成しました。'
    else
      flash.now[:alert] = 'タスクを作成できませんでした。'
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @task.update(task_params)
      redirect_to users_team_task_path(@task), notice: 'タスク情報を更新しました。'
    else
      flash.now[:alert] = 'タスク情報を更新できませんでした。'
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @task.destroy!
    redirect_to users_team_path, notice: 'タスクを削除しました。', status: :see_other
  end

  private

  def task_params
    params.expect(team: %i[title description completed])
  end

  def set_team
    @team = current_user.team
  end

  def set_task
    @task = @team.tasks.find(params[:id])
  end
end
