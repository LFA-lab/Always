class ServiceRequestsController < ApplicationController
  def new
    @service_request = ServiceRequest.new
  end

  def create
    @service_request = ServiceRequest.new(service_request_params)
    @service_request.user = current_user
    if @service_request.save
      redirect_to dashboards_path, notice: "Votre demande a été envoyée. Un responsable vous contactera prochainement."
    else
      render :new
    end
  end

  def show
    @service_request = ServiceRequest.find(params[:id])
  end

  private

  def service_request_params
    params.require(:service_request).permit(:description, :status)
  end
end
