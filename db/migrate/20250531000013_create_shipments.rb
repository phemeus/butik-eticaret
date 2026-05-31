# frozen_string_literal: true

class CreateShipments < ActiveRecord::Migration[8.0]
  def change
    create_table :shipments do |t|
      t.references :order, null: false, foreign_key: true, index: { unique: true }
      t.string :tracking_number
      t.string :carrier
      t.datetime :shipped_at

      t.timestamps
    end
  end
end
