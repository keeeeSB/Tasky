class Users::SessionsController < Devise::SessionsController
  protected

  def after_sign_in_path_for(resource)
    if (token = session.delete(:team_invitation_token))
      invitation = TeamInvitation.find_by(token:)

      if invitation&.expires_at&.future?
        ActiveRecord::Base.transaction do
          resource.update!(team: invitation.team)
          invitation.destroy!
        end

        flash[:notice] = 'チームに参加しました。'
        root_path
      end
    end

    super
  end
end
