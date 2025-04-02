module Api
  class GuidesController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :set_guide, only: [:show, :update, :destroy]

    def index
      @guides = Guide.all
      render json: @guides
    end

    def show
      render json: @guide
    end

    def create
      @guide = Guide.new(guide_params)
      
      if @guide.save
        render json: @guide, status: :created
      else
        render json: @guide.errors, status: :unprocessable_entity
      end
    end

    def update
      if @guide.update(guide_params)
        render json: @guide
      else
        render json: @guide.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @guide.destroy
      head :no_content
    end

    private

    def set_guide
      @guide = Guide.find(params[:id])
    end

    def guide_params
      params.require(:guide).permit(:title, :content, :url, :screenshots)
    end
  end
end 