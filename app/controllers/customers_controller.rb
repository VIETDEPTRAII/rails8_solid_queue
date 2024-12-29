class CustomersController < ApplicationController
  layout "solid-queue"

  def index
    @customers = Customer.page(params[:page])
  end

  def export_csv
    user_email = params[:email]
    ExportCustomersCsvJob.perform_later(user_email)
    flash[:success] = "CSV export is being processed. You will receive an email when it is ready."
    redirect_to customers_path
  end
end
