# frozen_string_literal: true

# Migration to create the areas table
class CreateAreas < ActiveRecord::Migration[7.0]
  def up
    enable_extension 'btree_gin'
    enable_extension 'pg_trgm'

    create_table :areas do |t|
      t.string :name, null: false
      t.string :region, null: false
      t.string :simple_search_field, null: false
      t.references :group, null: false, foreign_key: true
      t.timestamps
    end

    add_index :areas, :simple_search_field, using: :gin, opclass: :gin_trgm_ops # , name: 'search_areas'
  end

  def down
    drop_index :areas, :simple_search_field
    drop_table :areas
  end
end
