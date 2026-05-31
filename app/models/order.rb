# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address
  belongs_to :coupon, optional: true
  has_many :order_items, dependent: :destroy
  has_one :payment, dependent: :destroy
  has_one :shipment, dependent: :destroy

  enum :status, {
    pending: 0,
    confirmed: 1,
    preparing: 2,
    shipped: 3,
    delivered: 4,
    cancelled: 5
  }, validate: true

  validates :subtotal_cents, :total_cents, :discount_cents, numericality: { greater_than_or_equal_to: 0 }

  scope :recent, -> { order(created_at: :desc) }
  scope :completed_sales, -> { where.not(status: :cancelled) }

  def self.create_from_cart!(user:, cart:, address:, notes: nil)
    raise ActiveRecord::RecordInvalid, cart if cart.empty?

    transaction do
      cart.cart_items.includes(product_variant: :product).each do |item|
        unless item.product_variant.in_stock?(item.quantity)
          cart.errors.add(:base, "#{item.product_variant.product.name} için stok yetersiz")
          raise ActiveRecord::RecordInvalid, cart
        end
      end

      subtotal = cart.subtotal_cents

      if cart.coupon.present? && !cart.coupon.applicable_to?(subtotal)
        cart.errors.add(:base, "Kupon artık geçerli değil")
        raise ActiveRecord::RecordInvalid, cart
      end

      discount = cart.discount_cents
      total = cart.total_cents

      order = create!(
        user: user,
        address: address,
        status: :pending,
        subtotal_cents: subtotal,
        discount_cents: discount,
        total_cents: total,
        coupon: cart.coupon,
        coupon_code: cart.coupon&.code,
        notes: notes
      )

      cart.cart_items.each do |item|
        variant = item.product_variant
        order.order_items.create!(
          product_variant: variant,
          product_name: variant.product.name,
          variant_label: variant.label.presence || "Standart",
          quantity: item.quantity,
          unit_price_cents: variant.effective_price_cents
        )
        variant.decrement!(:stock, item.quantity)
      end

      order.create_payment!(status: :pending, amount_cents: total)
      order.create_shipment!
      cart.coupon&.redeem!
      cart.update!(coupon: nil)
      cart.cart_items.destroy_all

      order
    end
  end
end
