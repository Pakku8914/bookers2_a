# Preview all emails at http://localhost:3000/rails/mailers/group_mailer
class GroupMailerPreview < ActionMailer::Preview
  def send_mail
    GroupMailer.with(title: 'test', content: 'test',
                    owner_email: 'owner@owner', owner_name: 'test',
                    user_email: 'user@user').send_mail
  end
end
