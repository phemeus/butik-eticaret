# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email_address, null: false
      t.string :password_digest, null: false
      t.string :full_name
      t.boolean :admin, null: false, default: false

      t.timestamps
    end

    add_index :users, :email_address, unique: true
    add_index :users, :admin
  end
end
