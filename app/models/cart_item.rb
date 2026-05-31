# frozen_string_literal: true

class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product_variant

  validates :quantity, numericality: { greater_than: 0, only_integer: true }
  validate :stock_available, on: :create
  validate :stock_available_on_update, on: :update

  def line_total_cents
    quantity * product_variant.effective_price_cents
  end

  private

  def stock_available
    return if product_variant&.in_stock?(quantity)

    errors.add(:quantity, "stok yetersiz")
  end

  def stock_available_on_update
    return if product_variant&.in_stock?(quantity)

    errors.add(:quantity, "stok yetersiz")
  end
end
