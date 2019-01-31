class Director < ApplicationRecord
  has_many :moviedirectors
  has_many :movies, through: :moviedirectors

  validates :name, presence: true
  validates :imdb_link, presence: true

end
