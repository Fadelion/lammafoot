class Admin::PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin
  before_action :set_payment, only: [ :show, :edit, :update, :destroy ]

  def index
    @payments = Payment.includes(:user, :booking).order(created_at: :desc)
  end

  def show
  end

  def edit
  end

  def update
    if @payment.update(payment_params)
      redirect_to admin_payment_path(@payment), notice: "Payment was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @payment.destroy
    redirect_to admin_payments_path, notice: "Payment was successfully destroyed."
  end

  private

  def set_payment
    @payment = Payment.find(params[:id])
  end

  def payment_params
    params.require(:payment).permit(:status, :payment_method, :amount)
  end
end