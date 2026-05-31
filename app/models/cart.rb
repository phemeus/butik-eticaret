# frozen_string_literal: true

class Cart < ApplicationRecord
  belongs_to :user
  belongs_to :coupon, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :product_variants, through: :cart_items

  def subtotal_cents
    cart_items.includes(product_variant: :product).sum(&:line_total_cents)
  end

  def discount_cents
    coupon&.discount_for(subtotal_cents).to_i
  end

  def total_cents
    [ subtotal_cents - discount_cents, 0 ].max
  end

  def item_count
    cart_items.sum(:quantity)
  end

  def empty?
    cart_items.none?
  end

  def apply_coupon!(code)
    found = Coupon.find_applicable(code)
    raise ActiveRecord::RecordNotFound unless found
    raise StandardError, "Bu kupon geçerli değil" unless found.applicable_to?(subtotal_cents)

    update!(coupon: found)
  end

  def remove_coupon!
    update!(coupon: nil)
  end
end
