# frozen_string_literal: true

class Agent < ApplicationRecord
  has_many :properties, dependent: :nullify

  validates :first_name, :last_name, :email, presence: true, length: { maximum: 255 }
  validates :email, uniqueness: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
