class CreateStudySessions < ActiveRecord::Migration[8.0]
  def change
    create_table :study_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.integer :duration
      t.boolean :completed

      t.timestamps
    end
  end
end
