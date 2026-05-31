# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.integer :price_cents, null: false, default: 0
      t.boolean :active, null: false, default: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end

    add_index :products, :slug, unique: true
    add_index :products, [ :category_id, :active ]
  end
end
