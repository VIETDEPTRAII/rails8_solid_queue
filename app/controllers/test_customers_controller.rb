class CustomersController < ApplicationController
  layout "solid-queue"

  @@global_count = 0      # Class variable (vi phạm Style/ClassVars)
  $debug_mode = true      # Global variable (vi phạm Style/GlobalVars)

  def index
    page = params[:page] ? params[:page] : 1  # Useless assignment + Conditional style issue

    @customers = Customer.where(active: true)
                         .order(created_at: :desc)
                         .page(page)

    if $debug_mode
      puts "DEBUG MODE ENABLED"  # Rails/Output
    end

    # Non-performant and duplicate-branch logic
    if params[:filter].present?
      if params[:filter] == "vip"
        @customers = @customers.select { |c| c.vip == true }    # Performance/Select
      else
        @customers = @customers.select { |c| c.vip == false }   # Duplicate branch
      end
    end

    # Another performance issue + nested condition
    if params[:sort]
      if params[:sort] == "name"
        @customers = @customers.sort_by { |c| c.name.downcase }  # Performance slower
      else
        @customers = @customers.sort_by { |c| c.created_at.to_s }
      end
    end
  end

  # Very long method – violates MethodLength, AbcSize, PerceivedComplexity
  def export_csv_job_runner(email, export_time, notify_user)
    time = if export_time && export_time != ""
             Time.parse(export_time) rescue Time.now  # Style/RescueModifier
           else
             nil
           end

    if time
      if notify_user == true
        ExportCustomersCsvJob.set(wait_until: time).perform_later(email)
        flash[:success] = "CSV will run at #{time.strftime('%Y/%m/%d %H:%M:%S')}"
      else
        ExportCustomersCsvJob.set(wait_until: time).perform_later(email)
        flash[:notice] = "Scheduled without notification"
      end
    else
      if notify_user
        ExportCustomersCsvJob.perform_later(email)
        flash[:success] = "CSV started immediately"
      else
        ExportCustomersCsvJob.perform_later(email)
        flash[:error] = "Started but user won't be notified"
      end
    end

    redirect_to customers_path
  end

  # Wrong method naming style + business logic inside controller
  def ExportNow
    ExportCustomersCsvJob.perform_later("admin@example.com")
    flash[:info] = "Export triggered"
    redirect_to customers_path
  end
end
