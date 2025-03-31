module Api
  module V1
    class GuidesController < BaseController
      before_action :set_guide, only: [:show, :update, :destroy]
      before_action :check_permissions, only: [:create, :update, :destroy, :capture]

      def index
        Rails.logger.info "📥 Requête GET /api/v1/guides"
        @guides = if current_user.manager?
                   current_user.enterprise.guides.includes(:steps)
                 else
                   Guide.joins(:parcours_guides)
                        .joins("INNER JOIN parcours ON parcours.id = parcours_guides.parcours_id")
                        .where(parcours: { user_id: current_user.id })
                        .includes(:steps)
                 end

        Rails.logger.info "✅ #{@guides.count} guides trouvés"
        render json: @guides.as_json(include: :steps)
      end

      def show
        Rails.logger.info "📥 Requête GET /api/v1/guides/#{params[:id]}"
        render json: @guide.as_json(include: :steps)
      end

      def create
        Rails.logger.info "📤 Requête POST /api/v1/guides"
        Rails.logger.info "📝 Paramètres reçus: #{guide_params.inspect}"
        
        @guide = current_user.guides.build(guide_params)
        @guide.enterprise = current_user.enterprise

        if @guide.save
          create_steps if params[:steps].present?
          Rails.logger.info "✅ Guide créé avec succès (ID: #{@guide.id})"
          render json: @guide.as_json(include: :steps), status: :created
        else
          Rails.logger.error "❌ Erreur lors de la création du guide: #{@guide.errors.full_messages.join(', ')}"
          render json: @guide.errors, status: :unprocessable_entity
        end
      end

      def update
        Rails.logger.info "📤 Requête PUT /api/v1/guides/#{params[:id]}"
        Rails.logger.info "📝 Paramètres reçus: #{guide_params.inspect}"
        
        if @guide.update(guide_params)
          update_steps if params[:steps].present?
          Rails.logger.info "✅ Guide mis à jour avec succès"
          render json: @guide.as_json(include: :steps)
        else
          Rails.logger.error "❌ Erreur lors de la mise à jour du guide: #{@guide.errors.full_messages.join(', ')}"
          render json: @guide.errors, status: :unprocessable_entity
        end
      end

      def destroy
        Rails.logger.info "📤 Requête DELETE /api/v1/guides/#{params[:id]}"
        
        if @guide.destroy
          Rails.logger.info "✅ Guide supprimé avec succès"
          render json: { message: 'Guide supprimé avec succès' }
        else
          Rails.logger.error "❌ Erreur lors de la suppression du guide: #{@guide.errors.full_messages.join(', ')}"
          render json: @guide.errors, status: :unprocessable_entity
        end
      end

      def capture
        Rails.logger.info "📤 Requête POST /api/v1/guides/capture"
        
        # Parse les données JSON si elles sont envoyées en tant que JSON
        if request.content_type == 'application/json'
          json_params = JSON.parse(request.body.read)
          params[:guide] = json_params['guide']
          params[:steps] = json_params['steps']
        end
        
        Rails.logger.info "📝 Paramètres reçus: #{params.inspect}"
        
        @guide = current_user.guides.build(guide_params)
        @guide.enterprise = current_user.enterprise
        @guide.visibility = 'private'
        @guide.status = 'draft'

        if @guide.save
          if params[:steps].present?
            create_steps
            Rails.logger.info "✅ Guide capturé avec succès (ID: #{@guide.id})"
            render json: {
              guide: @guide.as_json(include: :steps),
              edit_url: edit_guide_url(@guide),
              message: 'Guide créé avec succès'
            }, status: :created
          else
            Rails.logger.error "❌ Aucune étape fournie"
            render json: { error: 'Aucune étape fournie' }, status: :unprocessable_entity
          end
        else
          Rails.logger.error "❌ Erreur lors de la capture du guide: #{@guide.errors.full_messages.join(', ')}"
          render json: @guide.errors, status: :unprocessable_entity
        end
      end

      private

      def set_guide
        @guide = Guide.find(params[:id])
      end

      def guide_params
        params.require(:guide).permit(
          :title,
          :description,
          :visibility,
          :status,
          :url,
          :browser_info,
          :device_info
        )
      end

      def check_permissions
        unless current_user.manager? || current_user.admin?
          Rails.logger.error "❌ Accès non autorisé pour l'utilisateur #{current_user.id}"
          render json: { error: 'Accès non autorisé' }, status: :forbidden
        end
      end

      def create_steps
        params[:steps].each_with_index do |step_data, index|
          step = @guide.steps.create!(
            instruction_text: step_data[:description],
            step_order: index + 1,
            visual_indicator: step_data[:type],
            element_selector: step_data[:element_selector],
            element_type: step_data[:element_type],
            element_text: step_data[:element_text],
            coordinates: step_data[:coordinates],
            scroll_position: step_data[:scroll_position],
            timestamp: step_data[:timestamp]
          )

          if step_data[:screenshot].present?
            process_screenshot(step, step_data[:screenshot])
          end
        end
      end

      def process_screenshot(step, screenshot_data)
        image_data = Base64.decode64(screenshot_data.split(',')[1])
        
        temp_file = Tempfile.new(['screenshot', '.png'])
        temp_file.binmode
        temp_file.write(image_data)
        temp_file.rewind

        step.screenshot.attach(
          io: temp_file,
          filename: "step_#{step.id}_screenshot.png",
          content_type: 'image/png'
        )

        temp_file.close
        temp_file.unlink
      end

      def update_steps
        @guide.steps.destroy_all
        create_steps
      end
    end
  end
end 