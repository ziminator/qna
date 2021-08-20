class SearchController < ApplicationController

  skip_authorization_check

  def search
    @data = service.result(search_params)
  end

  private

  def service
    @service ||= Services::Search.new
  end

  def search_params
    params.permit(%i[query question answer comment user page utf8 commit])
  end
end
