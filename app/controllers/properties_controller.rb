# frozen_string_literal: true

class PropertiesController < ApplicationController
  before_action :find_property, only: %i[show edit update destroy]

  # GET /properties
  def index
    @properties = Rails.cache.fetch('properties/all', expires_in: 1.hour) do
      Property.includes(:agent).all.to_a
    end
  end

  # GET /properties/1
  def show; end

  # GET /properties/new
  def new
    @property = Property.new
    cached_agents
  end

  # GET /properties/1/edit
  def edit
    cached_agents
  end

  # POST /properties
  def create
    manager = PropertyManager.new(params: property_params).create
    @property = manager.property

    if manager.success
      redirect_to @property, notice: t('.success')
    else
      cached_agents
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /properties/1
  def update
    manager = PropertyManager.new(params: property_params, property: @property).update
    @property = manager.property
    if manager.success
      redirect_to @property, notice: t('.success')
    else
      cached_agents
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /properties/1
  def destroy
    @property.destroy
    redirect_to properties_url, notice: t('.success')
  end

  private

  def find_property
    @property = Property.includes(:agent).find(params[:id])
  end

  def property_params
    params.require(:property).permit(:agent_id, :location, :name, :price, :status)
  end

  def cached_agents
    @agents = Rails.cache.fetch('agents/all/for_select', expires_in: 1.hour) do
      Agent.all.map do |agent|
        [agent.full_name, agent.id]
      end
    end
  end
end
