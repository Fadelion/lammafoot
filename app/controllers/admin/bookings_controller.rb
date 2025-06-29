class Admin::BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  
  def index
    @bookings = Booking.includes(:user, :stadium).order(created_at: :desc)
  end
  
  def show
    @payment = @booking.payment
  end
  
  def new
    @booking = Booking.new
    @users = User.all
    @stadia = Stadium.all
  end
  
  def create
    @booking = Booking.new(booking_params)
    
    if @booking.save
      redirect_to admin_booking_path(@booking), notice: 'Booking was successfully created.'
    else
      @users = User.all
      @stadia = Stadium.all
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    @users = User.all
    @stadia = Stadium.all
  end
  
  def update
    if @booking.update(booking_params)
      redirect_to admin_booking_path(@booking), notice: 'Booking was successfully updated.'
    else
      @users = User.all
      @stadia = Stadium.all
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @booking.destroy
    redirect_to admin_bookings_path, notice: 'Booking was successfully destroyed.'
  end
  
  private
  
  def set_booking
    @booking = Booking.find(params[:id])
  end
  
  def booking_params
    params.require(:booking).permit(:user_id, :stadium_id, :start_date, :end_date, :status)
  end
end