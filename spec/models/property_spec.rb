# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Property, type: :model do
  it do
    should define_enum_for(:status)
      .with_values(
        available: 'available',
        sold: 'sold'
      ).backed_by_column_of_type(:string)
  end

  describe 'associations' do
    it { should belong_to(:agent).optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:status) }
    it { should validate_length_of(:name).is_at_most(255) }
  end

  describe 'delegations' do
    it { should delegate_method(:full_name).to(:agent).with_prefix(true).allow_nil }
  end
end
