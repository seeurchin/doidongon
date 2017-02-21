class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:avatar])
    #devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :current_password, :avatar) }
  end

  # rescue_from CanCan::AccessDenied do |exception|
  #   flash[:notice] = "test msg"
  #   redirect_to new_user_session_path
  # end

  # rescue_from CanCan::AccessDenied do |exception|
  #   puts "*************test****************"
  #   Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}
  #   render :file => "#{Rails.root}/public/404.html", :status => 403, :layout => false
  #   respond_to do |format|
  #     format.json { head :forbidden }
  #     format.html { redirect_to root_path, :alert => exception.message }
  #     format.js
  #   end
  # end

  def after_sign_in_path_for(resource)
    sign_in_url = new_user_session_url
    if request.referer == sign_in_url
      super
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end

  def authenticate_user!
    if user_signed_in?
      super
    else
      #render "devise/sessions/new"
      respond_to do |format|
        format.json { head :forbidden }
        format.html { render "devise/sessions/new" }
        format.js { render "devise/sessions/new" }
      end
    end
  end
end
