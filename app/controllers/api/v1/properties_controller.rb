# frozen_string_literal: true

module Api
  module V1
    class PropertiesController < Api::ApplicationController
      before_action :find_property, only: %i[show update destroy]

      # GET /properties
      def index
        @properties = Rails.cache.fetch('api/v1/properties/all', expires_in: 1.hour) do
          Property.all.to_a
        end

        render json: @properties
      end

      # GET /properties/1
      def show
        render json: @property
      end

      # POST /properties
      def create
        manager = PropertyManager.new(params: property_params).create
        @property = manager.property

        if manager.success
          render json: @property, status: :created
        else
          render json: { errors: @property.errors }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /properties/1
      def update
        manager = PropertyManager.new(params: property_params, property: @property).update
        @property = manager.property
        if manager.success
          render json: @property
        else
          render json: { errors: @property.errors }, status: :unprocessable_entity
        end
      end

      # DELETE /properties/1
      def destroy
        @property.destroy!
        head :no_content
      end

      private

      def find_property
        @property = Property.includes(:agent).find(params[:id])
      end

      def property_params
        params.require(:property).permit(:agent_id, :location, :name, :price, :status)
      end
    end
  end
end
