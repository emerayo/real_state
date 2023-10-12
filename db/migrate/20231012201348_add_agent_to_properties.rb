# frozen_string_literal: true

class AddAgentToProperties < ActiveRecord::Migration[7.0]
  def change
    add_reference :properties, :agent
  end
end
