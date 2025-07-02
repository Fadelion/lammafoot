class ApplicationMailer < ActionMailer::Base
  default from: ENV["SENDGRID_FROM_EMAIL"] || "noreply@lammafoot.com"
  layout "mailer"
end
