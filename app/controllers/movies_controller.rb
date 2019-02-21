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
    @all_ratings = Movie.all_ratings
    
    @sort = params[:sort] || session[:sort]
    session[:sort] = @sort
    @ratings = params[:ratings] || session[:ratings]
    session[:ratings] = @ratings
    
    if @sort != params[:sort] || @ratings != params[:ratings]
      flash.keep
      redirect_to movies_path(:sort => @sort, :ratings => @ratings)
    end
    
    
    if @ratings
      @checked_ratings = @ratings.keys
    else 
      @checked_ratings = @all_ratings
    end
    
    if @sort
      @movies = Movie.order(@sort).where(rating: @checked_ratings)
      if @sort.eql?("title")
        @title_header_css = "hilite"
      elsif @sort.eql?("release_date")
        @release_date_header_css = "hilite"
      end
    else
      @movies = Movie.where(rating: @checked_ratings)
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
