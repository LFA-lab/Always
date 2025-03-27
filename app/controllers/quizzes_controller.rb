class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show, :edit, :update, :destroy]

  def show
    # Afficher le quiz pour un guide
  end

  def new
    @quiz = Quiz.new
  end

  def create
    @quiz = Quiz.new(quiz_params)
    if @quiz.save
      redirect_to @quiz, notice: "Quiz créé avec succès."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @quiz.update(quiz_params)
      redirect_to @quiz, notice: "Quiz mis à jour avec succès."
    else
      render :edit
    end
  end

  def destroy
    @quiz.destroy
    redirect_to guides_path, notice: "Quiz supprimé."
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:id])
  end

  def quiz_params
    params.require(:quiz).permit(:guide_id)
  end
end
