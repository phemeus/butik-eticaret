# frozen_string_literal: true

class CreateSiteSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :site_settings do |t|
      t.string :site_name, null: false, default: "Butik"
      t.string :tagline, default: "Premium butik moda. Seçkin parçalar, sade alışveriş deneyimi."
      t.string :contact_email
      t.string :hero_eyebrow, default: "Yeni Sezon 2026"
      t.string :hero_title, default: "Zamansız parçalar, modern siluetler"
      t.text :hero_description, default: "Kadın ve erkek koleksiyonlarımızda premium kumaşlar, sade kesimler ve günlük şıklık bir arada."
      t.string :newsletter_title, default: "İlk alışverişinizde %10 indirim"
      t.text :newsletter_body, default: "Yeni koleksiyonlar ve özel kampanyalardan haberdar olun."
      t.integer :free_shipping_threshold_cents, null: false, default: 50_000
      t.integer :pdp_layout, null: false, default: 0

      t.timestamps
    end
  end
end
