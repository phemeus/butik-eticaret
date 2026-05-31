# frozen_string_literal: true

class Product < ApplicationRecord
  include Slugifiable
  include Highlightable
  include SeoMeta

  belongs_to :category
  has_many :product_variants, dependent: :destroy
  has_many_attached :images

  scope :active, -> { where(active: true) }

  validates :name, presence: true
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }
  validate :featured_until_requires_featured
  validate :new_arrival_until_requires_new_arrival

  def price
    price_cents / 100.0
  end

  def price=(value)
    self.price_cents = (value.to_f * 100).round
  end

  def display_price_cents
    product_variants.minimum(:price_cents) || price_cents
  end

  def in_stock?
    product_variants.where("stock > 0").exists?
  end

  def out_of_stock_variants
    product_variants.where(stock: 0)
  end

  private

  def default_seo_description
    description.to_s.truncate(155)
  end

  def featured_until_requires_featured
    return unless featured_until.present? && !featured?

    errors.add(:featured_until, "için öne çıkar işaretlenmeli")
  end

  def new_arrival_until_requires_new_arrival
    return unless new_arrival_until.present? && !new_arrival?

    errors.add(:new_arrival_until, "için yeni işaretlenmeli")
  end
end
