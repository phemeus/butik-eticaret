# frozen_string_literal: true

class AddSeoToProductsAndCategories < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :meta_title, :string
    add_column :products, :meta_description, :string, limit: 320

    add_column :categories, :meta_title, :string
    add_column :categories, :meta_description, :string, limit: 320
  end
end
