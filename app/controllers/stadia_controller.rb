class StadiaController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :authorize_admin, except: [ :index, :show ]
  before_action :set_stadium, only: [ :show, :edit, :update, :destroy ]

  def index
    @stadia = Stadium.all
  end

  def show
    @reviews = @stadium.reviews.includes(:user).order(created_at: :desc)
    @review = Review.new
    @booking = Booking.new
  end

  def new
    @stadium = Stadium.new
  end

  def create
    @stadium = Stadium.new(stadium_params)

    if @stadium.save
      redirect_to @stadium, notice: "Stadium was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @stadium.update(stadium_params)
      redirect_to @stadium, notice: "Stadium was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @stadium.destroy
    redirect_to stadia_url, notice: "Stadium was successfully destroyed."
  end

  private
    def set_stadium
      @stadium = Stadium.find(params[:id])
    end

    def stadium_params
      params.require(:stadium).permit(:name, :location, :price, :capacity, :description)
    end
end
