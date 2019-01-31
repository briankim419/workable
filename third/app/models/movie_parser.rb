require 'httparty'
require 'pry'

class MovieParser
  attr_reader :data

  BASE_PATH = "https://api.themoviedb.org/3/movie/"
  NOW_PLAYING = "now_playing?api_key="
  CAST_PATH = "/credits?api_key=bbb0e77b94b09193e6f32d5fac7a3b9c"
  API_KEY = ENV["THEMOVIEDB"]

  PERSON_BASE_PATH = "https://api.themoviedb.org/3/person/"
  EXTERNAL_ID_PATH = "/external_ids?api_key=bbb0e77b94b09193e6f32d5fac7a3b9c&language=en-US"

  def initialize
    @data = []
  end

  def currently_playing_movies(country_id)
    url = "#{BASE_PATH}#{NOW_PLAYING}#{API_KEY}&region=#{country_id}"
    response = HTTParty.get(url)
    json_response = JSON.parse(response.body)
    all_response = json_response["results"]
    all_response.each do |movie|
      movie_data = {
        title: movie["title"],
        description: movie["overview"],
        original_title: movie["original_title"],
        id: movie["id"],
        director: []
      }

      @data << movie_data
      url = "#{BASE_PATH}#{movie_data[:id]}#{CAST_PATH}"
      response = HTTParty.get(url)
      json_response = JSON.parse(response.body)

      crew_list = response["crew"]
      director_list = {}
      if crew_list != nil && crew_list.length > 0
        crew_list.each do |crew|
          if crew["job"] == "Director"
            director_list[crew["name"]] = crew["id"]
          end
        end
        if director_list != nil && director_list.length > 0
          director_list.each do |name, id|
            url = "#{PERSON_BASE_PATH}#{id}#{EXTERNAL_ID_PATH}"
            response = HTTParty.get(url)
            json_response = JSON.parse(response.body)
            imdb_link = "https://www.imdb.com/name/#{json_response["imdb_id"]}"
            director_data = {
              id: id,
              name: name,
              imdb: imdb_link
            }
            movie_data[:director] << director_data
          end
        end
      end
    end
    @data
  end
end
