# frozen_string_literal: true

class AddCouponToCartsAndOrders < ActiveRecord::Migration[8.0]
  def change
    add_reference :carts, :coupon, foreign_key: true
    add_column :orders, :coupon_code, :string
    add_column :orders, :discount_cents, :integer, null: false, default: 0
    add_reference :orders, :coupon, foreign_key: true
  end
end
