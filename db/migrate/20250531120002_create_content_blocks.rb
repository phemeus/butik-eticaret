# frozen_string_literal: true

class CreateContentBlocks < ActiveRecord::Migration[8.0]
  def change
    create_table :content_blocks do |t|
      t.string :title, null: false
      t.text :body
      t.string :icon, null: false, default: "star"
      t.integer :section, null: false, default: 0
      t.integer :position, null: false, default: 0
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :content_blocks, [ :section, :position ]
    add_index :content_blocks, [ :section, :active ]
  end
end
