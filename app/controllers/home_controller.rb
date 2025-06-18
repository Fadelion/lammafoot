class HomeController < ApplicationController
  def index
    @stadia = Stadium.order(created_at: :desc).limit(6)
  end
end
