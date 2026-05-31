# frozen_string_literal: true

class ContentBlock < ApplicationRecord
  enum :section, { trust: 0, promo: 1 }, validate: true

  validates :title, presence: true
  validates :icon, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :published, -> { where(active: true).order(:position) }
  scope :for_section, ->(section) { published.where(section: section) }

  ICON_OPTIONS = %w[
    truck arrow-repeat shield-check headset gift star heart
    credit-card clock geo-alt tag percent
  ].freeze
end
