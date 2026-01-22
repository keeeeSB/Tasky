class TeamInvitationMailer < ApplicationMailer
  def invite(invitation)
    @invitation = invitation
    @team = invitation.team
    @invite_url = accpet_team_invitations_url(token: invitation.token)

    mail to: invitation.email, subject: 'チーム招待のお知らせ'
  end
end
