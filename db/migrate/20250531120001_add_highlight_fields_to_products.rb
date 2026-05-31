# frozen_string_literal: true

class AddHighlightFieldsToProducts < ActiveRecord::Migration[8.0]
  def change
    change_table :products, bulk: true do |t|
      t.boolean :featured, null: false, default: false
      t.boolean :new_arrival, null: false, default: false
      t.datetime :featured_until
      t.datetime :new_arrival_until
    end

    add_index :products, :featured
    add_index :products, :new_arrival
  end
end
