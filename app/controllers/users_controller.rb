class UsersController < ApplicationController

  skip_authorization_check

  def finish_sign_up
    redirect_to root_path if user.email_verified?

    if request_is_patch?
      if user.update(user_params)
        flash[:notice] = 'A confirmation email has been sent to your email address'
      end
    end
  end

  private

  helper_method :user

  def user_params
    params.require(:user).permit(:email)
  end

  def user
    @user ||= User.find(params[:id])
  end

  def request_is_patch?
    request.patch? && params[:user]
  end
end
