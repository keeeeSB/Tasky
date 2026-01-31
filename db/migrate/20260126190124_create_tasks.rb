class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.references :team, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description, null: false
      t.boolean :completed, null: false, default: false

      t.timestamps
    end
  end
end
