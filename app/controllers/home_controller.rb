class HomeController < ApplicationController
  require_permission :none, only: %i[status index cookies landing_page]

  def index
    redirect_to ccs_homepage_url
  end

  def status
    render layout: false
  end

  def cookies; end

  def landing_page; end
end
