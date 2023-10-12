# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/agents', type: :request do
  let(:valid_attributes) do
    {
      first_name: 'John',
      last_name: 'Doe',
      email: 'email@gmail.com'
    }
  end

  let(:invalid_attributes) do
    {
      first_name: 'John',
      last_name: 'Doe',
      email: ''
    }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      get agents_url

      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      agent = Agent.create! valid_attributes

      get agent_url(agent)

      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_agent_url

      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      agent = Agent.create! valid_attributes

      get edit_agent_url(agent)

      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Agent and redirects to the created agent' do
        expect { post agents_url, params: { agent: valid_attributes } }
          .to change(Agent, :count).from(0).to(1)
        expect(response).to redirect_to(agent_url(Agent.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Agent and renders a response with 422 status' do
        expect { post agents_url, params: { agent: invalid_attributes } }
          .to change(Agent, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          first_name: 'James'
        }
      end

      it 'updates the requested agent and redirects to the agent' do
        agent = Agent.create! valid_attributes

        patch agent_url(agent), params: { agent: new_attributes }

        agent.reload
        expect(agent.first_name).to eq 'James'
        expect(response).to redirect_to(agent_url(agent))
      end
    end

    context 'with invalid parameters' do
      it 'renders a response with 422 status (i.e. to display the edit template)' do
        agent = Agent.create! valid_attributes

        patch agent_url(agent), params: { agent: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested agent and redirects to the properties list' do
      agent = Agent.create! valid_attributes

      expect { delete agent_url(agent) }.to change(Agent, :count).by(-1)
      expect(response).to redirect_to(agents_url)
    end
  end
end
