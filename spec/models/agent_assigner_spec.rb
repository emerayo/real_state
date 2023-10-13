# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AgentAssigner do
  let(:valid_attributes) do
    {
      name: 'Big House with 5 bedrooms',
      location: 'Fifth Avenue 1500, New York, NY',
      price: 1_500_000,
      status: 'available'
    }
  end

  let(:invalid_attributes) do
    {
      name: nil,
      location: 'Fifth Avenue 1500, New York, NY',
      price: 1_500_000,
      status: 'available'
    }
  end

  let(:agent) { Agent.create(first_name: 'John', last_name: 'Doe', email: 'email@email.com') }

  let(:assigner) { AgentAssigner.new }

  let!(:property) { Property.create(valid_attributes) }

  before do
    # Need to clear the cached agents ids
    Rails.cache.delete('agents/all/ids')
  end

  describe '#property_created_without_agent' do
    context 'when there is at least one Agent' do
      it 'adds an Agent to the Property and broadcasts the event' do
        agent

        expect(property.agent_id).to be_nil

        expect { assigner.property_created_without_agent(property.id) }
          .to broadcast(:property_created_with_agent, property.id)

        property.reload
        expect(property.agent_id).to eq agent.id
      end
    end

    context 'when there is no Agent in database' do
      it 'raises a RuntimeError' do
        expect(property.agent_id).to be_nil

        expect { assigner.property_created_without_agent(property.id) }.to raise_error(RuntimeError)
      end
    end
  end

  describe '#property_updated_without_agent' do
    context 'when there is at least one Agent' do
      it 'adds an Agent to the Property and broadcasts the event' do
        agent

        expect(property.agent_id).to be_nil

        expect { assigner.property_updated_without_agent(property.id) }
          .to broadcast(:property_updated_with_agent, property.id)

        property.reload
        expect(property.agent_id).to eq agent.id
      end
    end

    context 'when there is no Agent in database' do
      it 'raises a RuntimeError' do
        expect(property.agent_id).to be_nil

        expect { assigner.property_updated_without_agent(property.id) }.to raise_error(RuntimeError)
      end
    end
  end
end
