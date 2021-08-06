class ApplicationController < ActionController::Base
  include Pundit

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  #check_authorization
end
