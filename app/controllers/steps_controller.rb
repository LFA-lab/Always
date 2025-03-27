class StepsController < ApplicationController
  before_action :set_step, only: [:update, :destroy]

  def create
    @guide = Guide.find(params[:guide_id])
    @step = @guide.steps.build(step_params)
    if @step.save
      redirect_to guide_path(@guide), notice: "Étape ajoutée avec succès."
    else
      redirect_to guide_path(@guide), alert: "Erreur lors de l'ajout de l'étape."
    end
  end

  def update
    if @step.update(step_params)
      redirect_to guide_path(@step.guide), notice: "Étape mise à jour avec succès."
    else
      render :edit
    end
  end

  def destroy
    guide = @step.guide
    @step.destroy
    redirect_to guide_path(guide), notice: "Étape supprimée."
  end

  private

  def set_step
    @step = Step.find(params[:id])
  end

  def step_params
    params.require(:step).permit(:step_order, :instruction_text, :screenshot_url)
  end
end
