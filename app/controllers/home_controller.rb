class HomeController < ApplicationController
  def index
    @stadia = Stadium.order(created_at: :desc).limit(6)
  end
  
  def email_test
    # Page de test des emails (développement uniquement)
  end
end
