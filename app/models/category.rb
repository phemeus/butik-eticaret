# frozen_string_literal: true

class Category < ApplicationRecord
  include Slugifiable
  include SeoMeta

  has_many :products, dependent: :restrict_with_error
  has_one_attached :image

  validates :name, presence: true

  after_commit :bust_storefront_categories_cache

  private

  def bust_storefront_categories_cache
    Rails.cache.delete("storefront/categories/v1")
  end

  def default_seo_description
    "#{name} kategorisindeki butik parçalar."
  end
end
