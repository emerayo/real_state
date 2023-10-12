# frozen_string_literal: true

class AgentsController < ApplicationController
  before_action :find_agent, only: %i[show edit update destroy]

  # GET /agents
  def index
    @agents = Agent.all
  end

  # GET /agents/1
  def show; end

  # GET /agents/new
  def new
    @agent = Agent.new
  end

  # GET /agents/1/edit
  def edit; end

  # POST /agents
  def create
    @agent = Agent.new(agent_params)

    if @agent.save
      redirect_to @agent, notice: t('.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /agents/1
  def update
    if @agent.update(agent_params)
      redirect_to @agent, notice: t('.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /agents/1
  def destroy
    @agent.destroy
    redirect_to agents_url, notice: t('.success')
  end

  private

  def find_agent
    @agent = Agent.find(params[:id])
  end

  def agent_params
    params.require(:agent).permit(:email, :first_name, :last_name)
  end
end
