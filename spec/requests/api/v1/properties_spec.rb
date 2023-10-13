# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/v1/properties', type: :request do
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

  let(:json_response) { response.parsed_body }

  describe 'GET /index' do
    before do
      Rails.cache.delete('api/v1/properties/all')
    end

    context 'when there is no Property in database' do
      it 'returns a blank array and status 200' do
        get api_v1_properties_path

        expect(json_response).to eq []
        expect(response.status).to eq 200
      end
    end

    context 'when there is no Property in database' do
      let!(:property) { Property.create! valid_attributes }

      it 'returns an array with the Property and status 200' do
        get api_v1_properties_path

        property_json = json_response.first

        expect(property_json['name']).to eq property.name
        expect(property_json['id']).to eq property.id
        expect(property_json['agent_id']).to eq property.agent_id
        expect(property_json['location']).to eq property.location
        expect(property_json['status']).to eq property.status
        expect(response.status).to eq 200
      end
    end
  end

  describe 'GET /show' do
    context 'when the Property exists' do
      let!(:property) { Property.create! valid_attributes }

      it 'returns the Property and status 200' do
        get api_v1_property_path(property)

        expect(json_response['name']).to eq property.name
        expect(json_response['id']).to eq property.id
        expect(json_response['agent_id']).to eq property.agent_id
        expect(json_response['location']).to eq property.location
        expect(json_response['status']).to eq property.status
        expect(response.status).to eq 200
      end
    end

    context 'when the Property does not exist' do
      it 'returns 404' do
        get api_v1_property_path(1)

        expect(json_response).to eq({ 'error' => 'not-found' })
        expect(response.status).to eq 404
      end
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
        expect { post api_v1_properties_path, params: { property: valid_attributes } }
          .to change(Property, :count).from(0).to(1)

        expect(json_response['name']).to eq valid_attributes[:name]
        expect(json_response['agent_id']).to eq valid_attributes[:agent_id]
        expect(json_response['location']).to eq valid_attributes[:location]
        expect(json_response['status']).to eq valid_attributes[:status]
        expect(response.status).to eq 201
      end

      it 'creates a new Property and assigns to an Agent' do
        agent = Agent.create(first_name: 'John', last_name: 'Doe', email: 'email@email.com')

        post api_v1_properties_path,
             params: { property: valid_attributes.merge(agent_id: agent.id) }

        agent.reload
        expect(agent.properties.count).to eq 1
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Property and renders a response with 422 status' do
        expect { post api_v1_properties_path, params: { property: invalid_attributes } }
          .to change(Property, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      before do
        # Mock the response from subscriber so it does not perform any actions
        allow_any_instance_of(AgentAssigner)
          .to receive(:property_updated_without_agent).and_return(true)
      end

      let(:new_attributes) do
        {
          name: 'Small house with 1 bedroom'
        }
      end

      it 'updates the requested property and redirects to the property' do
        property = Property.create! valid_attributes

        patch api_v1_property_path(property), params: { property: new_attributes }

        expect(json_response['name']).to eq 'Small house with 1 bedroom'
        expect(json_response['id']).to eq property.id
        expect(json_response['agent_id']).to eq property.agent_id
        expect(json_response['location']).to eq property.location
        expect(json_response['status']).to eq property.status
        expect(response.status).to eq 200
      end
    end

    context 'with invalid parameters' do
      it 'renders the errors and a status 422' do
        property = Property.create! valid_attributes

        patch api_v1_property_path(property), params: { property: invalid_attributes }

        expect(json_response).to eq({ 'errors' => { 'name' => ["can't be blank"] } })
        expect(response.status).to eq 422
      end
    end

    context 'when the Property does not exist' do
      it 'returns 404' do
        patch api_v1_property_path(2), params: { property: invalid_attributes }

        expect(json_response).to eq({ 'error' => 'not-found' })
        expect(response.status).to eq 404
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested property and redirects to the properties list' do
      property = Property.create! valid_attributes

      expect { delete api_v1_property_path(property) }.to change(Property, :count).by(-1)
      expect(response.status).to eq 204
    end

    context 'when the Property does not exist' do
      it 'returns 404' do
        delete api_v1_property_path(2), params: { property: invalid_attributes }

        expect(json_response).to eq({ 'error' => 'not-found' })
        expect(response.status).to eq 404
      end
    end
  end
end
