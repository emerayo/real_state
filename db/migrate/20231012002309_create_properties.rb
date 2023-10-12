# frozen_string_literal: true

class CreateProperties < ActiveRecord::Migration[7.0]
  def change
    create_table :properties do |t|
      t.string :name
      # Just in case we have too many info on this field
      t.text :location
      t.float :price
      t.string :status

      t.timestamps
    end
  end
end
