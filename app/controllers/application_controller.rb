class ApplicationController < ActionController::API
  before_filter :set_access_control_headers

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = 'http://walter-cavinaw.github.io'
  end



end
