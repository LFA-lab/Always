class PagesController < ApplicationController
  def about
  end

  def contact
  end

  def privacy
  end

  def terms
  end

  def home
    @total_hours_saved = GuideFeedback.sum(:time_saved)
    @total_guides = Guide.published.count
    @total_users = User.count
    
    # Récupérer les derniers feedbacks pour l'affichage
    @latest_feedbacks = GuideFeedback.includes(:guide)
                                   .order(created_at: :desc)
                                   .limit(3)
  end
end 