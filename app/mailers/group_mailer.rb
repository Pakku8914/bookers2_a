class GroupMailer < ApplicationMailer
  def send_mail
    mail(
      from: params[:owner_email],
      to: params[:user_email],
      subject: params[:title]
    )
  end
end
