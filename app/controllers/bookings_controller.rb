class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: [ :show, :edit, :update, :destroy, :cancel, :complete ]
  before_action :authorize_booking_owner, only: [ :show, :edit, :update, :destroy, :cancel ]
  before_action :set_stadium, only: [ :new, :create ]

  def index
    @bookings = current_user.bookings.includes(:stadium).order(start_date: :desc)
  end

  def show
  end

  def new
    @booking = @stadium.bookings.new
  end

  def create
    # Gestion de la réservation rapide depuis la page d'accueil
    if params[:stadium_id].present?
      @stadium = Stadium.find(params[:stadium_id])
      @booking = @stadium.bookings.new

      # Conversion des paramètres du modal en format attendu
      if params[:booking_date].present? && params[:booking_time].present?
        booking_datetime = DateTime.parse("#{params[:booking_date]} #{params[:booking_time]}")
        @booking.start_date = booking_datetime
        @booking.end_date = booking_datetime + 2.hours # Durée par défaut de 2h
      end

      @booking.user = current_user
      @booking.user_name = params[:user_name] if params[:user_name].present?
      @booking.user_email = params[:user_email] if params[:user_email].present?

      if @booking.save
        # Créer le paiement avec la méthode sélectionnée
        if params[:payment_method].present?
          @booking.create_payment(
            user: current_user,
            amount: @booking.total_price,
            payment_method: params[:payment_method],
            status: "pending"
          )
        end

        BookingMailer.booking_confirmation(@booking).deliver_now
        redirect_to new_booking_payment_path(@booking), notice: "Réservation créée avec succès. Un email de confirmation vous a été envoyé. Veuillez procéder au paiement."
      else
        redirect_to root_path, alert: "Erreur lors de la création de la réservation. Veuillez réessayer."
      end
    else
      # Réservation normale depuis la page dédiée
      @booking = @stadium.bookings.new(booking_params)
      @booking.user = current_user

      if @booking.save
        BookingMailer.booking_confirmation(@booking).deliver_now
        redirect_to new_booking_payment_path(@booking), notice: "Réservation créée avec succès. Un email de confirmation vous a été envoyé. Veuillez procéder au paiement."
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit
  end

  def update
    if @booking.update(booking_params)
      redirect_to @booking, notice: "Booking was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @booking.destroy
    redirect_to bookings_url, notice: "Booking was successfully cancelled."
  end

  def cancel
    if @booking.update(status: "cancelled")
      # Envoyer l'email d'annulation
      BookingMailer.booking_cancelled(@booking).deliver_now
      redirect_to bookings_path, notice: "Réservation annulée avec succès. Un email de confirmation vous a été envoyé."
    else
      redirect_to @booking, alert: "Impossible d'annuler la réservation."
    end
  end

  def complete
    if current_user.role == "admin" && @booking.update(status: "completed")
      redirect_to @booking, notice: "Booking was marked as completed."
    else
      redirect_to @booking, alert: "Unable to complete booking."
    end
  end

  private
    def set_booking
      @booking = Booking.find(params[:id])
    end

    def set_stadium
      @stadium = Stadium.find(params[:stadium_id]) if params[:stadium_id].present?
    end

    def authorize_booking_owner
      unless @booking.user == current_user || current_user.role == "admin"
        redirect_to bookings_path, alert: "You are not authorized to access this booking."
      end
    end

    def booking_params
      params.require(:booking).permit(:start_date, :end_date, :user_name, :user_email)
    end
end
