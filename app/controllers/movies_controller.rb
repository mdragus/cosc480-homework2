# in app/controllers/movies_controller.rb

class MoviesController < ApplicationController
  def index
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
    @movies = Movie.all(:order => params[:sort_by])
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
