# frozen_string_literal: true

class ProductVariant < ApplicationRecord
  belongs_to :product
  has_many :cart_items, dependent: :restrict_with_error
  has_many :stock_notifications, dependent: :destroy

  after_update :notify_stock_waitlist, if: :saved_change_to_stock?

  validates :sku, presence: true, uniqueness: true
  validates :stock, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :color, uniqueness: { scope: [ :product_id, :size ] }

  def price
    return nil if price_cents.nil?

    price_cents / 100.0
  end

  def price=(value)
    self.price_cents = value.present? ? (value.to_f * 100).round : nil
  end

  def effective_price_cents
    price_cents || product.price_cents
  end

  def label
    [ color, size ].compact_blank.join(" / ")
  end

  def in_stock?(requested = 1)
    stock >= requested
  end

  private

  def notify_stock_waitlist
    return unless stock_before_last_save.to_i.zero? && stock.positive?

    StockNotification.notify_for_variant!(self)
  end
end
