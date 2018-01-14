class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # @movies = Movie.all
    @all_ratings = Movie.ratings
    if params[:ratings]
      @movies = Movie.where(:rating => params[:ratings].keys)
      @current_ratings = params[:ratings]
    else
      @movies = Movie.all
      @current_ratings = Hash[@all_ratings.zip [1,1,1,1]]
    end
    
    sort = params[:sort]
    if sort == 'title'
      @movies = Movie.order(:title)
      @title = 'hilite'
    elsif sort == 'release_date'
      @movies = Movie.order(:release_date)
      @release = 'hilite'
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
