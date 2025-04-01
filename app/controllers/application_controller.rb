class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, unless: :skip_authentication?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :service, :enterprise_id])
  end

  def skip_authentication?
    devise_controller? || public_page? || privacy_policy_page? || request.path == '/privacy-policy'
  end

  def public_page?
    params[:controller] == 'pages' && ['about', 'contact', 'privacy', 'terms', 'home'].include?(params[:action])
  end

  def privacy_policy_page?
    params[:controller] == 'pages' && params[:action] == 'privacy_policy'
  end
end
