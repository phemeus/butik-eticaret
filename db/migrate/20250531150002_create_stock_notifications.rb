# frozen_string_literal: true

class CreateStockNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :stock_notifications do |t|
      t.references :product_variant, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.string :email, null: false
      t.datetime :notified_at

      t.timestamps
    end

    add_index :stock_notifications, [ :email, :product_variant_id ],
              unique: true,
              where: "notified_at IS NULL",
              name: "index_stock_notifications_pending_unique"
  end
end
