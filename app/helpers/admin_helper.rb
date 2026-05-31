# frozen_string_literal: true

module AdminHelper
  def admin_nav_link(section, label, path, icon:)
    active = admin_section_active?(section)
    link_to path, class: "admin-nav__link #{'is-active' if active}", aria: { current: active ? "page" : false } do
      tag.i("", class: "bi bi-#{icon}", aria: { hidden: true }) + label
    end
  end

  def admin_section_active?(section)
    controller = params[:controller]

    case section
    when :dashboard
      controller == "admin/dashboard"
    when :products
      controller.in?(%w[admin/products admin/product_variants])
    when :categories
      controller == "admin/categories"
    when :orders
      controller == "admin/orders"
    when :content_blocks
      controller == "admin/content_blocks"
    when :site_settings
      controller == "admin/site_settings"
    when :coupons
      controller == "admin/coupons"
    when :reports
      controller == "admin/reports"
    else
      false
    end
  end

  def admin_status_dot(active)
    css = active ? "success" : "secondary"
    tag.span("", class: "badge bg-#{css} rounded-pill", style: "width:0.5rem;height:0.5rem;padding:0", title: active ? "Aktif" : "Pasif")
  end
end
