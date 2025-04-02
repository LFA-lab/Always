class CustomFailure < Devise::FailureApp
  def call
    super
  end
end
