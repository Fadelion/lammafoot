class EmailTestController < ApplicationController
  def send_test_email
    email = params[:email].presence || 'test@example.com'
    use_sendgrid = params[:use_sendgrid] == '1'
    
    TestMailer.test_email(email).deliver_now
    
    if use_sendgrid || ENV['USE_SENDGRID'] == 'true'
      redirect_back(fallback_location: root_path, notice: "Email envoyé via SendGrid à #{email}. Vérifiez votre boîte email.")
    else
      redirect_to '/letter_opener', notice: "Email capturé pour #{email}. Consultez Letter Opener Web."
    end
  rescue => e
    redirect_back(fallback_location: root_path, alert: "Erreur lors de l'envoi: #{e.message}")
  end
end