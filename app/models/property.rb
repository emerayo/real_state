# frozen_string_literal: true

class Property < ApplicationRecord
  enum status: {
    available: 'available',
    sold: 'sold'
  }

  belongs_to :agent, optional: true

  validates :location, presence: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :price, presence: true
end
