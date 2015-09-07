class HoldingsController < ApplicationController
  before_action :set_holding, only: [:show, :update, :destroy]

  # GET /holdings
  # GET /holdings.json
  def index
    @holdings = Holding.all

    render json: @holdings
  end

  # GET /holdings/1
  # GET /holdings/1.json
  def show
    render json: @holding
  end

  # POST /holdings
  # POST /holdings.json
  def create
    @holding = Holding.new(holding_params)

    if @holding.save
      render json: @holding, status: :created, location: @holding
    else
      render json: @holding.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /holdings/1
  # PATCH/PUT /holdings/1.json
  def update
    @holding = Holding.find(params[:id])

    if @holding.update(holding_params)
      head :no_content
    else
      render json: @holding.errors, status: :unprocessable_entity
    end
  end

  # DELETE /holdings/1
  # DELETE /holdings/1.json
  def destroy
    @holding.destroy

    head :no_content
  end

  private

    def set_holding
      @holding = Holding.find(params[:id])
    end

    def holding_params
      params.require(:holding).permit(:weight, :security_id, :portfolio_id)
    end
end
