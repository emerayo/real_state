# frozen_string_literal: true

class PropertyManager
  include Wisper::Publisher

  attr_accessor :property, :success

  def initialize(params:, property: nil)
    @params = params
    @property = property
    @success = false
  end

  def create
    @property = Property.new(@params)

    @success = @property.save
    broadcast_create if @success
    self
  end

  def update
    unless @property.is_a? Property
      raise ArgumentError,
            'Property should be an instance of Property'
    end

    @success = @property.update(@params)
    broadcast_update if @success
    self
  end

  private

  def broadcast_create
    if @property.agent_id.present?
      publish(:property_created_with_agent, property.id)
    else
      publish(:property_created_without_agent, property.id)
    end
  end

  def broadcast_update
    if @property.agent_id.present?
      publish(:property_updated_with_agent, property.id)
    else
      publish(:property_updated_without_agent, property.id)
    end
  end
end
