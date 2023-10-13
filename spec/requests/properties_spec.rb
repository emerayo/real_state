# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/properties', type: :request do
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

  describe 'GET /index' do
    it 'renders a successful response' do
      get properties_url

      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      property = Property.create! valid_attributes

      get property_url(property)

      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_property_url

      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      property = Property.create! valid_attributes

      get edit_property_url(property)

      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      before do
        # Mock the response from subscriber so it does not perform any actions
        allow_any_instance_of(AgentAssigner)
          .to receive(:property_created_without_agent).and_return(true)
      end

      it 'creates a new Property and redirects to the created property' do
        expect { post properties_url, params: { property: valid_attributes } }
          .to change(Property, :count).from(0).to(1)
        expect(response).to redirect_to(property_url(Property.last))
      end

      it 'creates a new Property and assigns to an Agent' do
        agent = Agent.create(first_name: 'John', last_name: 'Doe', email: 'email@email.com')

        post properties_url, params: { property: valid_attributes.merge(agent_id: agent.id) }

        agent.reload
        expect(agent.properties.count).to eq 1
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Property and renders a response with 422 status' do
        expect { post properties_url, params: { property: invalid_attributes } }
          .to change(Property, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          name: 'Small house with 1 bedroom'
        }
      end

      before do
        # Mock the response from subscriber so it does not perform any actions
        allow_any_instance_of(AgentAssigner)
          .to receive(:property_updated_without_agent).and_return(true)
      end

      it 'updates the requested property and redirects to the property' do
        property = Property.create! valid_attributes

        patch property_url(property), params: { property: new_attributes }

        property.reload
        expect(property.name).to eq 'Small house with 1 bedroom'
        expect(response).to redirect_to(property_url(property))
      end
    end

    context 'with invalid parameters' do
      it 'renders a response with 422 status (i.e. to display the edit template)' do
        property = Property.create! valid_attributes

        patch property_url(property), params: { property: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested property and redirects to the properties list' do
      property = Property.create! valid_attributes

      expect { delete property_url(property) }.to change(Property, :count).by(-1)
      expect(response).to redirect_to(properties_url)
    end
  end
end
