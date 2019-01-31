class Api::V1::MovieApiController < ApplicationController

  def get_currently_playing_movies
    movie_parser = MovieParser.new
    movie_parser.currently_playing_movies(params[:country_id])
    movie_parser.data.each do |movie|
      title = movie[:title]
      description = movie[:description]
      original_title = movie[:original_title]
      id = movie[:id]
      director_data = []
      if movie[:director] != nil && movie[:director].length > 0
        movie[:director].each do |movie_director|
          director = {}
          director["name"] = movie_director[:name]
          director["imdb_link"] = movie_director[:imdb]
          Director.create(name: director["name"], imdb_link: director["imdb_link"])
        end
      end

      Movie.create(title: title, description: description, original_title: original_title)

    end
    render json: { data: movie_parser.data}
  end
end
