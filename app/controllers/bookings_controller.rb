class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: [:show, :edit, :update, :destroy, :cancel, :complete]
  before_action :authorize_booking_owner, only: [:show, :edit, :update, :destroy, :cancel]
  before_action :set_stadium, only: [:new, :create]

  def index
    @bookings = current_user.bookings.includes(:stadium).order(start_date: :desc)
  end

  def show
  end

  def new
    @booking = @stadium.bookings.new
  end

  def create
    @booking = @stadium.bookings.new(booking_params)
    @booking.user = current_user

    if @booking.save
      redirect_to new_booking_payment_path(@booking), notice: 'Booking was successfully created. Please proceed to payment.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @booking.update(booking_params)
      redirect_to @booking, notice: 'Booking was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @booking.destroy
    redirect_to bookings_url, notice: 'Booking was successfully cancelled.'
  end
  
  def cancel
    if @booking.update(status: 'cancelled')
      redirect_to bookings_path, notice: 'Booking was successfully cancelled.'
    else
      redirect_to @booking, alert: 'Unable to cancel booking.'
    end
  end
  
  def complete
    if current_user.role == 'admin' && @booking.update(status: 'completed')
      redirect_to @booking, notice: 'Booking was marked as completed.'
    else
      redirect_to @booking, alert: 'Unable to complete booking.'
    end
  end

  private
    def set_booking
      @booking = Booking.find(params[:id])
    end
    
    def set_stadium
      @stadium = Stadium.find(params[:stadium_id])
    end
    
    def authorize_booking_owner
      unless @booking.user == current_user || current_user.role == 'admin'
        redirect_to bookings_path, alert: 'You are not authorized to access this booking.'
      end
    end

    def booking_params
      params.require(:booking).permit(:start_date, :end_date)
    end
end
