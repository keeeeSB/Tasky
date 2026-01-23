class AddTeamIdToUsers < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :team, foreign_key: true
  end
end
