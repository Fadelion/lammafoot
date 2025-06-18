class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking
  before_action :authorize_payment_owner
  before_action :set_payment, only: [:show]

  def new
    @payment = @booking.payment || Payment.new(booking: @booking, user: current_user, amount: @booking.total_price)
  end

  def create
    @payment = Payment.new(payment_params)
    @payment.booking = @booking
    @payment.user = current_user
    @payment.amount = @booking.total_price

    if @payment.save
      @booking.update(status: 'confirmed')
      redirect_to booking_path(@booking), notice: 'Payment was successfully processed.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  private
    def set_booking
      @booking = Booking.find(params[:booking_id])
    end
    
    def set_payment
      @payment = @booking.payment
    end
    
    def authorize_payment_owner
      unless @booking.user == current_user || current_user.role == 'admin'
        redirect_to bookings_path, alert: 'You are not authorized to access this payment.'
      end
    end

    def payment_params
      params.require(:payment).permit(:payment_method)
    end
end
