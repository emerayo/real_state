# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PropertyManager do
  let(:valid_attributes) do
    {
      name: 'Big House with 5 bedrooms',
      location: 'Fifth Avenue 1500, New York, NY',
      price: 1_500_000
    }
  end

  let(:invalid_attributes) do
    {
      name: nil,
      location: 'Fifth Avenue 1500, New York, NY',
      price: 1_500_000
    }
  end

  let(:agent) { Agent.create(first_name: 'John', last_name: 'Doe', email: 'email@email.com') }

  let(:manager) { PropertyManager.new(params: valid_attributes) }

  describe '#create' do
    context 'with valid parameters but not an Agent' do
      before do
        # Mock the response from subscriber so it does not perform any actions
        allow_any_instance_of(AgentAssigner)
          .to receive(:property_created_without_agent).and_return(true)
      end

      it 'creates a new Property' do
        expect { manager.create }.to change(Property, :count).from(0).to(1)
        expect(manager.success).to eq true
      end

      it 'broadcast the event' do
        expect { manager.create }
          .to broadcast(:property_created_without_agent)
        expect(manager.success).to eq true
      end
    end

    context 'with valid parameters and an Agent' do
      let(:manager) { PropertyManager.new(params: valid_attributes.merge(agent_id: agent.id)) }

      it 'creates a new Property' do
        expect { manager.create }.to change(Property, :count).from(0).to(1)
        expect(manager.success).to eq true
      end

      it 'broadcast the event' do
        expect { manager.create }
          .to broadcast(:property_created_with_agent)
          .and not_broadcast(:property_created_without_agent)
        expect(manager.success).to eq true
      end
    end

    context 'with invalid parameters' do
      let(:manager) { PropertyManager.new(params: invalid_attributes) }

      it 'does not create a new Property and does not broadcast any event' do
        expect { manager.create }
          .to not_broadcast(:property_created_without_agent)
          .and not_broadcast(:property_created_with_agent)
        expect(manager.success).to eq false
      end
    end
  end

  describe '#update' do
    let!(:property) { Property.create(valid_attributes) }

    context 'with valid parameters but not an Agent' do
      let(:manager) { PropertyManager.new(params: { name: 'new name' }, property: property) }

      before do
        # Mock the response from subscriber so it does not perform any actions
        allow_any_instance_of(AgentAssigner)
          .to receive(:property_updated_without_agent).and_return(true)
      end

      it 'updates Property field' do
        expect { manager.update }.not_to change(Property, :count)
        expect(manager.success).to eq true
        expect(manager.property.name).to eq 'new name'
      end

      it 'broadcast the event' do
        expect { manager.update }
          .to broadcast(:property_updated_without_agent)
        expect(manager.success).to eq true
      end
    end

    context 'with valid parameters and an Agent' do
      let!(:property_with_agent) { Property.create(valid_attributes.merge(agent_id: agent.id)) }
      let(:manager) do
        PropertyManager.new(params: { name: 'new name' }, property: property_with_agent)
      end

      it 'updates Property field' do
        expect { manager.update }.not_to change(Property, :count)
        expect(manager.success).to eq true
        expect(manager.property.name).to eq 'new name'
      end

      it 'broadcast the event' do
        expect { manager.update }
          .to broadcast(:property_updated_with_agent, property_with_agent.id)
          .and not_broadcast(:property_updated_without_agent)
        expect(manager.success).to eq true
      end
    end

    context 'with invalid parameters' do
      it 'does not update the Property and does not broadcast any event' do
        manager = PropertyManager.new(params: { name: nil }, property: property)

        expect { manager.update }
          .to not_broadcast(:property_updated_without_agent)
          .and not_broadcast(:property_updated_with_agent)
        expect(manager.success).to eq false
      end

      it 'raises an error when Property is not a Property record' do
        manager = PropertyManager.new(params: { name: nil }, property: true)

        expect { manager.update }.to raise_error(ArgumentError)
      end
    end
  end
end
