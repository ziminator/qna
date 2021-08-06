class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :oauth

  skip_authorization_check

  def github; end

  def vkontakte; end

  def instagram; end

  private

  def oauth
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: action_name.capitalize) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def after_sign_in_path_for(resource)
    if resource.email_verified?
      super resource
    else
      finish_sign_up_path(resource)
    end
  end
end
