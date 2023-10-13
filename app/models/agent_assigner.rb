# frozen_string_literal: true

class AgentAssigner
  include Wisper::Publisher

  def property_created_with_agent(_property_id)
    # TODO: - This method will email the agent
  end

  def property_created_without_agent(property_id)
    property(property_id)
    assign_agent!
    publish(:property_created_with_agent, property_id)
  end

  def property_updated_with_agent(_property_id)
    # TODO: - This method will email the agent
  end

  def property_updated_without_agent(property_id)
    property(property_id)
    assign_agent!
    publish(:property_updated_with_agent, property_id)
  end

  private

  def property(id)
    @property ||= Property.find(id)
  end

  def assign_agent!
    @property.agent_id = available_agents.sample

    raise 'No Agent in database, cannot assign to Property' if @property.agent_id.blank?

    @property.save!
  end

  def available_agents
    Rails.cache.fetch('agents/all/ids', expires_in: 1.hour) do
      Agent.pluck(:id)
    end
  end
end
