class GuidesController < ApplicationController
  before_action :set_guide, only: [:show, :edit, :update, :destroy]

  def index
    # Pour un manager, afficher les guides de son entreprise
    @guides = current_user.manager? ? current_user.enterprise.guides : Guide.all
  end

  def show
  end

  def new
    @guide = current_user.guides.build
  end

  def create
    @guide = current_user.guides.build(guide_params)
    if @guide.save
      redirect_to @guide, notice: "Guide créé avec succès."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @guide.update(guide_params)
      redirect_to @guide, notice: "Guide mis à jour avec succès."
    else
      render :edit
    end
  end

  def destroy
    @guide.destroy
    redirect_to guides_url, notice: "Guide supprimé."
  end

  private

  def set_guide
    @guide = Guide.find(params[:id])
  end

  def guide_params
    params.require(:guide).permit(:title, :description, :visibility, :slug)
  end
end
