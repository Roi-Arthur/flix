class ReviewsController < ApplicationController

  before_action :require_signin, except: [:index]
  before_action :set_movie

  def index
    @reviews = @movie.reviews
    #@reviews = Review.all
    #@reviews = Review.find_by(movie: @movie)
  end

  def new
    @review = @movie.reviews.new
  end

  def create
    @review = @movie.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to movie_reviews_path(@movie), message:"Thanks for your review!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @review = Review.find(params[:id])
  end

  def update
    @review = Review.find(params[:id])
    if @review.update(review_params)
      redirect_to movie_reviews_path, message: "Thanks for editing your review."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to movie_reviews_path
  end

  private

    def review_params
      params.require(:review).permit(:stars, :comment)
    end

    def set_movie
      @movie = Movie.find(params[:movie_id])
    end

end
