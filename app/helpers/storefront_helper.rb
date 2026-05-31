# frozen_string_literal: true

module StorefrontHelper
  def product_image(product, size: [ 600, 750 ], css_class: "product-card__img")
    if product.images.attached?
      attachment_image_tag(
        product.images.first,
        resize: size,
        class: css_class,
        alt: product.name,
        loading: "lazy"
      )
    else
      content_tag(:div, class: "#{css_class} product-card__placeholder", role: "img", aria: { label: product.name }) do
        tag.i("", class: "bi bi-image")
      end
    end
  end

  def product_card_badge(product)
    if product.featured_active?
      content_tag(:span, "Öne Çıkan", class: "product-card__badge")
    elsif product.new_arrival_active?
      content_tag(:span, "Yeni", class: "product-card__badge")
    end
  end

  def category_image(category, css_class: "sf-cat-tile__img")
    if category.image.attached?
      attachment_image_tag(
        category.image,
        resize: [ 600, 750 ],
        class: css_class,
        alt: category.name,
        loading: "lazy"
      )
    else
      content_tag(:div, class: "sf-cat-tile__placeholder") do
        tag.span(category.name.first.upcase, class: "sf-cat-tile__initial")
      end
    end
  end

  def storefront_icon(name, label: nil)
    tag.i("", class: "bi bi-#{name}", aria: { hidden: true }) +
      (label ? content_tag(:span, label, class: "visually-hidden") : "".html_safe)
  end
end
