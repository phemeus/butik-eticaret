# frozen_string_literal: true

class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.string :full_name, null: false
      t.string :phone, null: false
      t.string :city, null: false
      t.string :district, null: false
      t.string :address_line, null: false
      t.string :postal_code

      t.timestamps
    end
  end
end
