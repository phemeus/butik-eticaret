# frozen_string_literal: true

module ActiveStorageHelper
  def attachment_image_tag(attachment, resize: nil, resize_mode: :fill, **options)
    return unless attachment&.attached?

    image_tag attachment_url_for(attachment, resize: resize, resize_mode: resize_mode), **options
  rescue StandardError => e
    Rails.logger.warn("ActiveStorage image failed: #{e.message}")
    begin
      image_tag attachment_url_for(attachment), **options
    rescue StandardError => fallback_error
      Rails.logger.warn("ActiveStorage fallback failed: #{fallback_error.message}")
      nil
    end
  end

  def attachment_url_for(attachment, resize: nil, resize_mode: :fill)
    if resize
      variant_options = resize_mode == :limit ? { resize_to_limit: resize } : { resize_to_fill: resize }
      url_for(attachment.variant(**variant_options))
    else
      url_for(attachment)
    end
  end
end
