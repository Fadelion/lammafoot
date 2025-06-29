class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin

  def index
    @users_count = User.count
    @stadia_count = Stadium.count
    @bookings_count = Booking.count
    @recent_bookings = Booking.includes(:user, :stadium).order(created_at: :desc).limit(10)
    @recent_users = User.order(created_at: :desc).limit(10)
  end
end
