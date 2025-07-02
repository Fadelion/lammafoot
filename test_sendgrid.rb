#!/usr/bin/env ruby

# Script de test pour SendGrid
require_relative 'config/environment'

puts "📧 Test de la configuration SendGrid"
puts "=" * 50

# Vérification des variables d'environnement
puts "🔍 Vérification de la configuration..."
puts "SENDGRID_API_KEY: #{ENV['SENDGRID_API_KEY'] ? '✅ Définie' : '❌ Manquante'}"
puts "SENDGRID_FROM_EMAIL: #{ENV['SENDGRID_FROM_EMAIL'] || '❌ Non définie'}"
puts "USE_SENDGRID: #{ENV['USE_SENDGRID'] || 'false'}"
puts ""

# Configuration actuelle
puts "📋 Configuration Action Mailer:"
puts "- Delivery method: #{ActionMailer::Base.delivery_method}"
puts "- Default from: #{ApplicationMailer.default[:from] || 'Non défini'}"
puts ""

if ENV['SENDGRID_API_KEY'].nil? || ENV['SENDGRID_API_KEY'].empty?
  puts "❌ ERREUR: SENDGRID_API_KEY n'est pas définie dans le fichier .env"
  exit 1
end

begin
  puts "📤 Test d'envoi avec SendGrid..."
  
  # Forcer l'utilisation de SendGrid temporairement
  original_method = ActionMailer::Base.delivery_method
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address: 'smtp.sendgrid.net',
    port: 587,
    domain: 'localhost',
    user_name: 'apikey',
    password: ENV['SENDGRID_API_KEY'],
    authentication: 'plain',
    enable_starttls_auto: true
  }
  
  # Envoi de l'email de test
  test_email = ENV['SENDGRID_FROM_EMAIL'] || 'johnnylaquality059@gmail.com'
  puts "📧 Envoi vers: #{test_email}"
  puts "📤 Depuis: #{ApplicationMailer.default[:from]}"
  
  email = TestMailer.test_email(test_email)
  email.deliver_now
  
  puts "✅ Email envoyé avec succès via SendGrid !"
  puts "📬 Vérifiez votre boîte email : #{test_email}"
  
  # Restaurer la configuration originale
  ActionMailer::Base.delivery_method = original_method
  
rescue => e
  puts "❌ Erreur lors de l'envoi : #{e.message}"
  puts "🔧 Vérifiez votre clé API SendGrid et votre email expéditeur"
end

puts "=" * 50