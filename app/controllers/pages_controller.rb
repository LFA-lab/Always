class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:about, :contact, :privacy, :terms, :home, :privacy_policy]
  before_action :check_role, only: [:dashboard_manager, :dashboard_user]

  def about
  end

  def contact
  end

  def privacy
  end

  def terms
  end

  def privacy_policy
    render layout: 'application'
  end

  def home
    if user_signed_in?
      @total_hours_saved = GuideFeedback.sum(:time_saved)
      @total_guides = Guide.published.count
      @total_users = User.count
      
      # Récupérer les derniers feedbacks pour l'affichage
      @latest_feedbacks = GuideFeedback.includes(:guide)
                                     .order(created_at: :desc)
                                     .limit(3)
    end
  end

  def dashboard_manager
    @guides = current_user.guides.includes(:steps, :guide_feedbacks)
    @total_guides = @guides.count
    @total_steps = @guides.joins(:steps).count
    @total_feedbacks = @guides.joins(:guide_feedbacks).count
    @average_rating = @guides.joins(:guide_feedbacks).average('guide_feedbacks.stars')
    
    @recent_guides = @guides.order(created_at: :desc).limit(5)
    @recent_feedbacks = GuideFeedback.includes(:guide)
                                   .where(guide: @guides)
                                   .order(created_at: :desc)
                                   .limit(5)
  end

  def dashboard_user
    @assigned_guides = Guide.joins(:parcours_guides)
                          .joins("INNER JOIN parcours ON parcours.id = parcours_guides.parcours_id")
                          .where(parcours: { user_id: current_user.id })
                          .includes(:steps, :guide_feedbacks)
    
    @completed_guides = @assigned_guides.joins(:guide_feedbacks)
                                      .where(guide_feedbacks: { user_id: current_user.id })
                                      .distinct
    
    @in_progress_guides = @assigned_guides.where.not(id: @completed_guides.pluck(:id))
    
    @recent_activity = GuideFeedback.includes(:guide)
                                  .where(user_id: current_user.id)
                                  .order(created_at: :desc)
                                  .limit(5)
  end

  private

  def check_role
    case action_name
    when 'dashboard_manager'
      unless current_user.manager? || current_user.admin?
        redirect_to dashboard_user_path, alert: "Accès non autorisé"
      end
    when 'dashboard_user'
      unless current_user.user? || current_user.admin?
        redirect_to dashboard_manager_path, alert: "Accès non autorisé"
      end
    end
  end
end 