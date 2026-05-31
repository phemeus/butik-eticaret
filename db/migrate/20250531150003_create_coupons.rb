# frozen_string_literal: true

class CreateCoupons < ActiveRecord::Migration[8.0]
  def change
    create_table :coupons do |t|
      t.string :code, null: false
      t.integer :discount_type, null: false, default: 0
      t.integer :discount_value, null: false
      t.integer :minimum_order_cents, null: false, default: 0
      t.integer :max_uses
      t.integer :times_used, null: false, default: 0
      t.datetime :expires_at
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :coupons, :code, unique: true
  end
end
