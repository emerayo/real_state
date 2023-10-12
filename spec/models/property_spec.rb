# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Property, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_length_of(:name).is_at_most(255) }
  end
end
