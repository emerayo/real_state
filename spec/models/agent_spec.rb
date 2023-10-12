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

  describe '#full_name' do
    it 'joins the first_name and last_name of an agent' do
      agent = Agent.create(first_name: 'John', last_name: 'Doe', email: 'email@email.com')

      full_name = agent.full_name

      expect(full_name).to eq 'John Doe'
    end
  end
end
