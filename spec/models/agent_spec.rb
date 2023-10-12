# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Agent, type: :model do
  describe 'associations' do
    it { should have_many(:properties).dependent(:nullify) }
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end
end
