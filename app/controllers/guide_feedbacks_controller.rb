class GuideFeedbacksController < ApplicationController
  def new
    @guide_feedback = GuideFeedback.new
    @guide = Guide.find(params[:guide_id])
  end

  def create
    @guide = Guide.find(params[:guide_id])
    @guide_feedback = @guide.guide_feedbacks.build(feedback_params)
    @guide_feedback.user = current_user if user_signed_in?
    if @guide_feedback.save
      redirect_to @guide, notice: "Merci pour votre feedback !"
    else
      render :new
    end
  end

  private

  def feedback_params
    params.require(:guide_feedback).permit(:stars, :comment)
  end
end
