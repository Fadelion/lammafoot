class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @bookings = current_user.bookings.includes(:stadium).order(start_date: :desc).limit(5)
    @reviews = current_user.reviews.includes(:stadium).order(created_at: :desc).limit(5)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(user_params)
      redirect_to profile_path, notice: "Profile was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone_number)
  end
end
