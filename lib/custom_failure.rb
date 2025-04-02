class CustomFailureApp < Devise::FailureApp
  def call
    super
  end
end 