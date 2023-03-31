# frozen_string_literal: true

# Migration to create the schedules table
class CreateSchedules < ActiveRecord::Migration[7.0]
  def up
    create_table :schedules do |t|
      t.string :day, null: false
      t.string :time, null: false
      t.references :group, null: false, foreign_key: true
      t.timestamps
    end
  end

  def down
    drop_table :schedules
  end
end
