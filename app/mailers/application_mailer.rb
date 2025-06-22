class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAILER_FROM'] || "noreply@foothall.com"
  layout "mailer"
end
