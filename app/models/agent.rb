# frozen_string_literal: true

class Agent < ApplicationRecord
  validates :first_name, :last_name, :email, presence: true, length: { maximum: 255 }
  validates :email, uniqueness: true
end
