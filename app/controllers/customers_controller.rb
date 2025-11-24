class CustomersController < ApplicationController
  layout 'solid-queue'

  def index
    @customers = Customer.page(params[:page])
  end

  def export_csv
    user_email = params[:email]
    export_time = params[:export_time]
    if export_time.present?
      time_to_run = Time.parse(export_time)
      ExportCustomersCsvJob.set(wait_until: time_to_run).perform_later(user_email)
      flash[:success] = "CSV export will process at #{time_to_run.strftime('%Y-%m-%d %H:%M:%S')}."
    else
      ExportCustomersCsvJob.perform_later(user_email)
      flash[:success] = 'CSV export is being processed. You will receive an email when it is ready.'
    end

    redirect_to customers_path
  end
end
