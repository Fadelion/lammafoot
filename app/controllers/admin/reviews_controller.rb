class Admin::ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin
  before_action :set_review, only: [ :show, :edit, :update, :destroy ]

  def index
    @reviews = Review.includes(:user, :stadium).order(created_at: :desc)
  end

  def show
  end

  def new
    @review = Review.new
    @users = User.all
    @stadia = Stadium.all
  end

  def create
    @review = Review.new(review_params)

    if @review.save
      redirect_to admin_review_path(@review), notice: "Review was successfully created."
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
    if @review.update(review_params)
      redirect_to admin_review_path(@review), notice: "Review was successfully updated."
    else
      @users = User.all
      @stadia = Stadium.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy
    redirect_to admin_reviews_path, notice: "Review was successfully destroyed."
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:user_id, :stadium_id, :rating, :comment)
  end
end
