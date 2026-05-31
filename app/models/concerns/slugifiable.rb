# frozen_string_literal: true

module Slugifiable
  extend ActiveSupport::Concern

  included do
    before_validation :generate_slug, if: -> { slug.blank? && name.present? }
    validates :slug, presence: true, uniqueness: true
  end

  class_methods do
    def find_by_param!(param)
      find_by(slug: param) || find(param)
    end
  end

  # Mağaza URL'leri slug kullanır; admin tarafında .id ile link verilir.
  def to_param
    slug
  end

  private

  def generate_slug
    base = name.to_s.parameterize
    candidate = base
    counter = 1

    while self.class.where.not(id: id).exists?(slug: candidate)
      counter += 1
      candidate = "#{base}-#{counter}"
    end

    self.slug = candidate
  end
end
