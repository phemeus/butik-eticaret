# frozen_string_literal: true

class CreateProductVariants < ActiveRecord::Migration[8.0]
  def change
    create_table :product_variants do |t|
      t.references :product, null: false, foreign_key: true
      t.string :color
      t.string :size
      t.integer :stock, null: false, default: 0
      t.string :sku, null: false
      t.integer :price_cents

      t.timestamps
    end

    add_index :product_variants, :sku, unique: true
    add_index :product_variants, [ :product_id, :color, :size ], unique: true
  end
end
