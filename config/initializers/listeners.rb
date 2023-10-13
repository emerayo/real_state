# frozen_string_literal: true

Rails.application.reloader.to_prepare do
  Wisper.subscribe(AgentAssigner.new)
end
