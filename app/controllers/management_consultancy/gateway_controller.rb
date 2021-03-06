module ManagementConsultancy
  class GatewayController < FrameworkController
    require_permission :none, only: :index

    def index
      redirect_to management_consultancy_path if logged_in?
    end
  end
end
