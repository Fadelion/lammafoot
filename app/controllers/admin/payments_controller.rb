class Admin::PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin
  before_action :set_payment, only: [:show, :edit, :update, :destroy]
  
  def index
    @payments = Payment.includes(:user, booking: :stadium).order(created_at: :desc)
  end
  
  def show
  end
  
  def new
    @payment = Payment.new
    @bookings = Booking.where(status: ['pending', 'confirmed']).includes(:user, :stadium)
    @users = User.all
  end
  
  def create
    @payment = Payment.new(payment_params)
    
    if @payment.save
      @payment.booking.update(status: 'confirmed')
      redirect_to admin_payment_path(@payment), notice: 'Payment was successfully created.'
    else
      @bookings = Booking.where(status: ['pending', 'confirmed']).includes(:user, :stadium)
      @users = User.all
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    @bookings = Booking.includes(:user, :stadium)
    @users = User.all
  end
  
  def update
    if @payment.update(payment_params)
      redirect_to admin_payment_path(@payment), notice: 'Payment was successfully updated.'
    else
      @bookings = Booking.includes(:user, :stadium)
      @users = User.all
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @payment.destroy
    redirect_to admin_payments_path, notice: 'Payment was successfully destroyed.'
  end
  
  private
  
  def set_payment
    @payment = Payment.find(params[:id])
  end
  
  def payment_params
    params.require(:payment).permit(:user_id, :booking_id, :amount, :payment_date, :payment_method, :status)
  end
end