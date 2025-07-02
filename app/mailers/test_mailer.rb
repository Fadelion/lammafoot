class TestMailer < ApplicationMailer
  default from: ENV['SENDGRID_FROM_EMAIL']

  def test_email(user_email = 'test@example.com')
    @user_email = user_email
    mail(
      to: @user_email,
      subject: 'Test Email - LammaFoot'
    )
  end
end
