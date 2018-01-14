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
    @all_ratings = Movie.ratings
    if params[:ratings]
      session[:ratings] = params[:ratings]
      @current_ratings = params[:ratings]
    elsif session[:ratings]
      @current_ratings = session[:ratings]
    else
      @current_ratings = Hash[@all_ratings.zip [1,1,1,1]]
    end
    
    if params[:sort] == 'title'
      session[:sort] = 'title'
      @movies = Movie.order(:title).where(:ratings => @current_ratings.keys)
      @title = 'hilite'
    elsif params[:sort] == 'release_date'
      session[:sort] = 'release_date'
      @movies = Movie.order(:release_date).where(reating: @current_ratings.keys)
      @release = 'hilite'
    elsif session[:sort]
      redirect_to movies_path(:sort => session[:sort], :rating => current_ratings)
    else
      @movies = Movie.where(:rating => @current_ratings.keys)
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
