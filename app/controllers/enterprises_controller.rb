class EnterprisesController < ApplicationController
  before_action :set_enterprise, only: [:show, :edit, :update, :destroy]

  def index
    @enterprises = Enterprise.all
  end

  def show
  end

  def new
    @enterprise = Enterprise.new
  end

  def create
    @enterprise = Enterprise.new(enterprise_params)
    if @enterprise.save
      redirect_to @enterprise, notice: "Entreprise créée avec succès."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @enterprise.update(enterprise_params)
      redirect_to @enterprise, notice: "Entreprise mise à jour avec succès."
    else
      render :edit
    end
  end

  def destroy
    @enterprise.destroy
    redirect_to enterprises_url, notice: "Entreprise supprimée."
  end

  private

  def set_enterprise
    @enterprise = Enterprise.find(params[:id])
  end

  def enterprise_params
    params.require(:enterprise).permit(:name, :address)
  end
end
