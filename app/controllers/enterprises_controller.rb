class EnterprisesController < ApplicationController
  before_action :set_enterprise, only: [:show, :edit, :update, :destroy, :dashboard]
  before_action :authenticate_user!
  before_action :ensure_manager, only: [:dashboard]

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

  def dashboard
    @users = @enterprise.users
    @guides = @enterprise.guides
    @parcours = @enterprise.parcours
    @total_users = @users.count
    @total_guides = @guides.count
    @total_parcours = @parcours.count
    @recent_guides = @guides.order(created_at: :desc).limit(5)
    @recent_users = @users.order(created_at: :desc).limit(5)
  end

  private

  def set_enterprise
    @enterprise = Enterprise.find(params[:id])
  end

  def enterprise_params
    params.require(:enterprise).permit(:name, :address)
  end

  def ensure_manager
    unless current_user.manager? && current_user.enterprise == @enterprise
      redirect_to root_path, alert: "Vous n'avez pas accès à cette page."
    end
  end
end
