# frozen_string_literal: true

# Migration to create the areas table
class CreateAreas < ActiveRecord::Migration[7.0]
  def up
    create_table :areas do |t|
      t.string :name, null: false, unique: true
      t.string :region, null: false
      t.references :group, null: false, foreign_key: true
      t.timestamps
    end

    add_index :areas, %i[name region], unique: true, opclass: :text_ops, using: :btree
  end

  def down
    drop_index :areas, %i[name region]
    drop_table :areas
  end
end
