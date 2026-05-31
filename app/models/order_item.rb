# frozen_string_literal: true

class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product_variant, optional: true

  validates :product_name, :variant_label, presence: true
  validates :quantity, numericality: { greater_than: 0, only_integer: true }
  validates :unit_price_cents, numericality: { greater_than_or_equal_to: 0 }

  def line_total_cents
    quantity * unit_price_cents
  end
end
