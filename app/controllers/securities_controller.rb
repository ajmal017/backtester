class SecuritiesController < ApplicationController
  before_action :set_security, only: [:show, :update, :destroy]
  before_action :set_security_by_name, only: [:named]

  # GET /securities
  # GET /securities.json
  def index
    @securities = Security.all

    render json: @securities
  end

  # GET /securities/1
  # GET /securities/1.json
  def show
    render json: @security
  end

  def named
    render json: @security
  end

  # POST /securities
  # POST /securities.json
  def create
    @security = Security.new(security_params)

    if @security.save
      render json: @security, status: :created, location: @security
    else
      render json: @security.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /securities/1
  # PATCH/PUT /securities/1.json
  def update
    @security = Security.find(params[:id])

    if @security.update(security_params)
      head :no_content
    else
      render json: @security.errors, status: :unprocessable_entity
    end
  end

  # DELETE /securities/1
  # DELETE /securities/1.json
  def destroy
    @security.destroy

    head :no_content
  end

  private

    def set_security_by_name
      @security = Security.find_by_ticker(params[:name])
      if @security == nil
        raise ActiveRecord::RecordNotFound
      end
    end

    def set_security
      @security = Security.find(params[:id])
    end

    def security_params
      params.require(:security).permit(:name, :ticker, :identifier)
    end
end
