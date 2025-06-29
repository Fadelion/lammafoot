class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]

  def index
    @users = User.all.order(created_at: :desc)
  end

  def show
    @bookings = @user.bookings.includes(:stadium).order(start_date: :desc)
    @reviews = @user.reviews.includes(:stadium).order(created_at: :desc)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_user_path(@user), notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "User was successfully destroyed."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    permitted_params = params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    permitted_params[:role] = params[:user][:role] if current_user.role == "admin"
    permitted_params
  end
end
