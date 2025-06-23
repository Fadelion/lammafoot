class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_stadium, only: [:new, :create]
  before_action :set_review, only: [:edit, :update, :destroy]
  before_action :authorize_review_owner, only: [:edit, :update, :destroy]

  def new
    @review = @stadium.reviews.new
  end

  def create
    @review = @stadium.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to stadium_path(@stadium), notice: 'Review was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to stadium_path(@review.stadium), notice: 'Review was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    stadium = @review.stadium
    @review.destroy
    redirect_to stadium_path(stadium), notice: 'Review was successfully destroyed.'
  end

  private
    def set_stadium
      @stadium = Stadium.find(params[:stadium_id])
    end
    
    def set_review
      @review = Review.find(params[:id])
    end
    
    def authorize_review_owner
      unless @review.user == current_user || current_user.role == 'admin'
        redirect_to stadium_path(@review.stadium), alert: 'You are not authorized to modify this review.'
      end
    end

    def review_params
      params.require(:review).permit(:rating, :comment)
    end
end
