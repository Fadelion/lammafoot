#!/usr/bin/env ruby

# Script de test pour vérifier la configuration des emails
require_relative 'config/environment'

puts "🧪 Test de la configuration Letter Opener Web"
puts "=" * 50

begin
  # Test de l'envoi d'email
  puts "📧 Envoi d'un email de test..."
  
  email = TestMailer.test_email('test@lammafoot.com')
  email.deliver_now
  
  puts "✅ Email envoyé avec succès !"
  puts "📍 Consultez vos emails sur : http://localhost:3000/letter_opener"
  puts ""
  puts "Configuration vérifiée :"
  puts "- Delivery method: #{ActionMailer::Base.delivery_method}"
  puts "- Default URL options: #{ActionMailer::Base.default_url_options}"
  
rescue => e
  puts "❌ Erreur lors de l'envoi : #{e.message}"
  puts "Vérifiez votre configuration dans config/environments/development.rb"
end

puts "=" * 50