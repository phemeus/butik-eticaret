# frozen_string_literal: true

puts "Seed başlıyor..."

admin = User.find_or_initialize_by(email_address: "admin@butik.com")
admin.assign_attributes(full_name: "Admin", password: "password123", admin: true)
admin.save!

customer = User.find_or_initialize_by(email_address: "musteri@butik.com")
customer.assign_attributes(full_name: "Demo Müşteri", password: "password123")
customer.save!
customer.create_cart! unless customer.cart

categories = [
  "Elbiseler",
  "Üst Giyim",
  "Aksesuar"
].map { |name| Category.find_or_create_by!(name: name) { |c| c.slug = name.parameterize } }

products_data = [
  { name: "İpek Midi Elbise", category: categories[0], price: 2499.00, color: "Siyah", size: "M", stock: 5, featured: true, new_arrival: true },
  { name: "Keten Bluz", category: categories[1], price: 899.00, color: "Bej", size: "S", stock: 8, featured: true, new_arrival: false },
  { name: "Deri Kemer", category: categories[2], price: 649.00, color: "Kahve", size: "Standart", stock: 12, featured: false, new_arrival: true }
]

products_data.each_with_index do |data, index|
  product = Product.find_or_initialize_by(name: data[:name])
  product.assign_attributes(
    category: data[:category],
    description: "Butik koleksiyonumuzdan özenle seçilmiş bir parça.",
    price: data[:price],
    active: true,
    featured: data[:featured],
    new_arrival: data[:new_arrival]
  )
  product.save!

  variant = product.product_variants.find_or_initialize_by(color: data[:color], size: data[:size])
  variant.assign_attributes(
    sku: "SKU-#{index + 1}-#{product.slug.upcase}",
    stock: data[:stock]
  )
  variant.save!
end

trust_blocks = [
  { title: "Hızlı Kargo", body: "500₺ üzeri ücretsiz teslimat", icon: "truck", position: 0 },
  { title: "Kolay İade", body: "14 gün içinde ücretsiz iade", icon: "arrow-repeat", position: 1 },
  { title: "Güvenli Ödeme", body: "256-bit SSL koruması", icon: "shield-check", position: 2 },
  { title: "Destek", body: "Hafta içi 09:00–18:00", icon: "headset", position: 3 }
]

trust_blocks.each do |attrs|
  block = ContentBlock.find_or_initialize_by(section: :trust, title: attrs[:title])
  block.assign_attributes(attrs.merge(active: true))
  block.save!
end

SiteSetting.current

Coupon.find_or_create_by!(code: "HOSGELDIN10") do |c|
  c.discount_type = :percent
  c.discount_value = 10
  c.minimum_order_cents = 0
  c.active = true
end

puts "Seed tamamlandı."
puts "Admin: admin@butik.com / password123"
puts "Müşteri: musteri@butik.com / password123"
