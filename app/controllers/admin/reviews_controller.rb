class Admin::ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin
  before_action :set_review, only: [ :show, :edit, :update, :destroy ]

  def index
    @reviews = Review.includes(:user, :stadium).order(created_at: :desc)
  end

  def show
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to admin_review_path(@review), notice: "Review was successfully updated."
    else
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
    params.require(:review).permit(:rating, :comment)
  end
end