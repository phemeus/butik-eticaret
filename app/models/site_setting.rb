# frozen_string_literal: true

class SiteSetting < ApplicationRecord
  has_one_attached :hero_image

  enum :pdp_layout, { full_width: 0, sidebar: 1 }, validate: true

  validates :site_name, presence: true
  validates :free_shipping_threshold_cents, numericality: { greater_than_or_equal_to: 0 }

  def self.current
    Rails.cache.fetch("site_setting/current/v1") { first || create! }
  end

  def self.reset_cache!
    Rails.cache.delete("site_setting/current/v1")
  end

  after_commit :bust_cache

  def bust_cache
    self.class.reset_cache!
  end

  def free_shipping_threshold
    free_shipping_threshold_cents / 100.0
  end

  def free_shipping_threshold=(value)
    self.free_shipping_threshold_cents = value.present? ? (value.to_f * 100).round : 0
  end
end
