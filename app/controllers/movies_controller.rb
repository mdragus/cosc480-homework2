# in app/controllers/movies_controller.rb

class MoviesController < ApplicationController
  
  def self.getRatingTypes
    Movie.uniq.pluck(:rating)
  end

  def index
    @all_ratings = MoviesController.getRatingTypes
    highlight_class = "hilite"
    if params[:sort_by] == "title"
      @title_class = highlight_class
    end
    if params[:sort_by] == "rating"
      @rating_class = highlight_class
    end
    if params[:sort_by] == "release_date"
      @release_date_class = highlight_class
    end
    requiredRatings = @all_ratings
    @selected_ratings = {}
    if !session.has_key?(:ratings) 
      session[:ratings] = {}
      @all_ratings.each { |rating| session[:ratings][rating] = 1}
    end
    if params[:ratings] == nil 
      return redirect_to movies_path(@movies, {:ratings => session[:ratings], :sort_by => session[:sort_by]}) 
    end
    session[:ratings] = {}
    requiredRatings = params[:ratings].keys
    requiredRatings.each do |rating|
      @selected_ratings[rating] = true
    end
    params[:ratings].each do |key, value|
      session[:ratings][key] = value
    end
    session[:sort_by] = params[:sort_by]
    @movies = Movie.where(:rating => requiredRatings).order(params[:sort_by])
  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
    # will render app/views/movies/show.html.haml by default
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
