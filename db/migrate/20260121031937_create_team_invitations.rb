class CreateTeamInvitations < ActiveRecord::Migration[8.0]
  def change
    create_table :team_invitations do |t|
      t.references :team, null: false, foreign_key: true
      t.string :email, null: false
      t.string :token, null: false
      t.datetime :expires_at, null: false
      t.datetime :accepted_at

      t.timestamps
    end

    add_index :team_invitations, %i[token], unique: true
  end
end
