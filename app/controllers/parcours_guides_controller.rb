class ParcoursGuidesController < ApplicationController
  before_action :set_parcours, only: [:index, :create, :destroy]
  before_action :set_guide, only: [:destroy]

  def index
    @guides = @parcours.guides
  end

  def create
    @guide = Guide.find(params[:guide_id])
    @parcours.guides << @guide
    
    if @parcours.save
      redirect_to @parcours, notice: "Guide ajouté au parcours avec succès."
    else
      redirect_to @parcours, alert: "Erreur lors de l'ajout du guide au parcours."
    end
  end

  def destroy
    @parcours.guides.delete(@guide)
    redirect_to @parcours, notice: "Guide retiré du parcours avec succès."
  end

  private

  def set_parcours
    @parcours = Parcours.find(params[:parcours_id])
  end

  def set_guide
    @guide = Guide.find(params[:id])
  end
end
