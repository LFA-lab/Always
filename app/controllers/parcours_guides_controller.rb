class ParcoursController < ApplicationController
  before_action :set_parcours, only: [:show, :edit, :update, :destroy]

  def index
    @parcours = Parcours.all
  end

  def show
  end

  def new
    @parcours = Parcours.new
  end

  def create
    @parcours = Parcours.new(parcours_params)
    if @parcours.save
      redirect_to @parcours, notice: "Parcours créé avec succès."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @parcours.update(parcours_params)
      redirect_to @parcours, notice: "Parcours mis à jour avec succès."
    else
      render :edit
    end
  end

  def destroy
    @parcours.destroy
    redirect_to parcours_index_path, notice: "Parcours supprimé."
  end

  private

  def set_parcours
    @parcours = Parcours.find(params[:id])
  end

  def parcours_params
    params.require(:parcours).permit(:title, :description)
  end
end
