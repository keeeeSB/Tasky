class Users::TeamsController < Users::ApplicationController
  def show
    @team = current_user.team
  end
end
