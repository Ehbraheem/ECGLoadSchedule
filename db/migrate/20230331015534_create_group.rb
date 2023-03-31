# frozen_string_literal: true

# Migration to create the groups table
class CreateGroup < ActiveRecord::Migration[7.0]
  def up
    create_table :groups do |t|
      t.string :name, null: false, unique: true
      t.string :description
      t.timestamps
    end
  end

  def down
    drop_table :groups
  end
end
