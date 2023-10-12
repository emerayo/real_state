# frozen_string_literal: true

class CreateAgents < ActiveRecord::Migration[7.0]
  def change
    create_table :agents do |t|
      t.string :first_name
      t.string :last_name
      t.string :email

      t.timestamps
    end

    add_index :agents, :email, unique: true
  end
end
