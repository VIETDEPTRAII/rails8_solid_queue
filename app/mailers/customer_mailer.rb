class CustomerMailer < ApplicationMailer
  def send_csv(user_email, file_path)
    attachments["customers-#{Date.today}.csv"] = File.read(file_path)
    mail(to: user_email, subject: "Your Customer Export is Ready")
  end
end
