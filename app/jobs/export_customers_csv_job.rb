require 'csv'

class ExportCustomersCsvJob < ApplicationJob
  queue_as :default

  def perform(user_email)
    customers = Customer.all

    csv_data = CSV.generate(headers: true) do |csv|
      csv << ['ID', 'Name', 'Email', 'Country', 'Phone', 'Age']
      customers.each do |customer|
        csv << [customer.id, customer.name, customer.email, customer.country, customer.phone, customer.age]
      end
    end

    file_path = Rails.root.join('tmp', "customers-#{Date.today}.csv")
    File.write(file_path, csv_data)
    CustomerMailer.send_csv(user_email, file_path).deliver_now
    File.delete(file_path) if File.exist?(file_path)
  end
end
