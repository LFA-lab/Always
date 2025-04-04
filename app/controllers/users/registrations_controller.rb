class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    build_resource(sign_up_params)
    
    # Si le rôle est manager, créer une nouvelle entreprise
    if resource.role == 'manager' && params[:user][:enterprise_attributes].present?
      enterprise = Enterprise.new(enterprise_params)
      if enterprise.save
        resource.enterprise = enterprise
      else
        resource.errors.add(:enterprise, enterprise.errors.full_messages.join(', '))
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource and return
      end
    end

    if resource.save
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Returns the token provided by the user from params in the session already to
  # be able to redirect back to it after sign up redirecting to another resource.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :service, :enterprise_id, :role, enterprise_attributes: [:name, :address]])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :service])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    root_path
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    root_path
  end

  private

  def enterprise_params
    params.require(:user).require(:enterprise_attributes).permit(:name, :address)
  end
end 