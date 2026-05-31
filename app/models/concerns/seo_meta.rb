# frozen_string_literal: true

module SeoMeta
  extend ActiveSupport::Concern

  def seo_title
    meta_title.presence || name
  end

  def seo_description
    meta_description.presence || default_seo_description
  end

  private

  def default_seo_description
    ""
  end
end
