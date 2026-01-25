class Admins::Teams::TeamInvitationsController < Admins::ApplicationController
  before_action :set_team

  def new
    @invitation = @team.team_invitations.build
  end

  def create
    @invitation = @team.team_invitations.build(invitation_params)
    if @invitation.save
      TeamInvitationMailer.invite(@invitation).deliver_now
      redirect_to admins_team_path(@team), notice: 'チーム招待メールを送信しました。'
    else
      flash.now[:alert] = 'チーム招待メールを送信できませんでした。'
      render :new, status: :unprocessable_content
    end
  end

  private

  def invitation_params
    params.expect(team_invitation: %i[email])
  end

  def set_team
    @team = Team.find(params[:team_id])
  end
end
