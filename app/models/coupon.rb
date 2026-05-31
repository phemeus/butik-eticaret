# frozen_string_literal: true

class Coupon < ApplicationRecord
  has_many :carts, dependent: :nullify
  has_many :orders, dependent: :nullify

  enum :discount_type, { percent: 0, fixed: 1 }, validate: true

  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :discount_value, numericality: { greater_than: 0 }
  validates :minimum_order_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :max_uses, numericality: { greater_than: 0 }, allow_nil: true
  validate :percent_discount_range

  before_validation :normalize_code

  scope :active, -> { where(active: true) }

  def self.find_applicable(code)
    active.find_by("LOWER(code) = ?", code.to_s.strip.downcase)
  end

  def expired?
    expires_at.present? && expires_at <= Time.current
  end

  def maxed_out?
    max_uses.present? && times_used >= max_uses
  end

  def applicable_to?(subtotal_cents)
    active? && !expired? && !maxed_out? && subtotal_cents >= minimum_order_cents
  end

  def discount_for(subtotal_cents)
    return 0 unless applicable_to?(subtotal_cents)

    amount = if percent?
      (subtotal_cents * discount_value / 100.0).round
    else
      discount_value
    end

    [ amount, subtotal_cents ].min
  end

  def label
    if percent?
      "%#{discount_value} indirim"
    else
      "#{discount_value / 100.0} TL indirim"
    end
  end

  def fixed_amount
    return nil unless fixed?

    discount_value / 100.0
  end

  def fixed_amount=(value)
    return if value.blank?

    self.discount_value = (value.to_f * 100).round
    self.discount_type = :fixed
  end

  def minimum_order
    minimum_order_cents / 100.0
  end

  def minimum_order=(value)
    self.minimum_order_cents = value.present? ? (value.to_f * 100).round : 0
  end

  def redeem!
    increment!(:times_used)
  end

  private

  def normalize_code
    self.code = code.to_s.strip.upcase if code.present?
  end

  def percent_discount_range
    return unless percent?

    errors.add(:discount_value, "1–100 arasında olmalı") unless discount_value.in?(1..100)
  end
end
