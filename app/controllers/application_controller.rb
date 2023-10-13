# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_found
    redirect_to properties_url, notice: t('not_found')
  end
end
