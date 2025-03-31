module Api
  module V1
    class InteractionsController < ApplicationController
      skip_before_action :verify_authenticity_token
      skip_before_action :authenticate_user!

      def create
        Rails.logger.info "📥 Requête POST /api/v1/interactions"
        Rails.logger.info "📝 Données reçues: #{params.inspect}"

        # Pour le moment, on ne fait que logger les interactions
        # On pourra les stocker plus tard si nécessaire
        Rails.logger.info "✅ Interaction enregistrée"
        render json: { status: 'success' }, status: :created
      end

      def index
        @interactions = current_user&.interactions
                                 &.includes(:guide)
                                 &.order(created_at: :desc)
                                 &.limit(50) || []

        render json: @interactions
      end

      private

      def interaction_params
        params.require(:interaction).permit(
          :guide_id,
          :action_type,
          :element_type,
          :element_selector,
          :element_text,
          :screenshot_url,
          :timestamp,
          :metadata
        )
      end
    end
  end
end 