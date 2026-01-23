class TeamInvitationsController < ApplicationController
  def accept
    invitation = TeamInvitation.find_by(token: params[:token])

    if invitation.nil? || invitation.expires_at < Time.current
      redirect_to root_path, alert: '無効なリンクです。'
      return
    end

    if user_signed_in?
      ActiveRecord::Base.transaction do
        current_user.update!(team: invitation.team)
        invitation.destroy!
      end
      redirect_to root_path, notice: 'チームに参加しました。'
    else
      session[:team_invitation_token] = invitation.token
      redirect_to new_user_session_path, notice: 'ログインしてください。'
    end
  end
end
