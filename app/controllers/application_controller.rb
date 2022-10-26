class ApplicationController < ActionController::Base
  def fallback_index_html
    render 'home/index'
  end
end
