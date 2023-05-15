class MoviesController < ApplicationController

  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]
  before_action :set_movie, only: [:show, :edit, :update, :destroy]

  def index
    @movies = Movie.send(movies_filter)
    #case params[:filter]
    #when "upcoming"
    #  @movies = Movie.upcoming
    #when "recent"
    #  @movies = Movie.recent
    #when "hits"
    #  @movies = Movie.hits
    #when "flops"
    #  @movies = Movie.flops
    #else
    #  @movies = Movie.released
    #end
  end

  def show
    @review = @movie.reviews.new
    @fans = @movie.fans
    @genres = @movie.genres.order(:name)

    if current_user
      @favorite = current_user.favorites.find_by(movie_id: params[:id])
    end

  end

  def edit
  end

  def update
    #movie_params = params.require(:movie).permit(:title, :description, :rating, :released_on, :total_gross)
    #movie_params = params[:movie].permit(:title, :description, :rating, :released_on, :total_gross)

    if @movie.update(movie_params)  # Now a private method
      redirect_to @movie, notice: "Movie successfully updated"
    else
      render :edit, status: :unprocessable_entity
    end

    #redirect_to show
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params) # Now a private method
    #movie_params = params.require(:movie).permit(:title, :description, :rating, :released_on, :total_gross)
    #movie_params = params[:movie].permit(:title, :description, :rating, :released_on, :total_gross)

    if @movie.save
      redirect_to @movie, notice: "Movie successfully created"
    else
      render :new, status: :unprocessable_entity
    end

  end

  def destroy
    @movie.destroy

    redirect_to movies_url, status: :see_other, alert: "Movie successfully deleted!" # can do movies_path, but _url is convention
    #redirect_to movies_url, status: :see_other, danger: "I'm sorry, Dave, I'm afraid I can't do that!"
  end

private
  def movie_params
    params.require(:movie).permit(:title, :description, :rating, :released_on, :total_gross, :director, :duration, :image_file_name, genre_ids: [])
  end

  def movies_filter
    if params[:filter].in? %w(upcoming recent hits flops)
      params[:filter]
    else
      :released
    end
  end

  def set_movie
    @movie = Movie.find_by!(slug: params[:id])
  end

end
