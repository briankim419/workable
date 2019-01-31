class Movie < ApplicationRecord
  has_many :moviedirectors
  has_many :directors, through: :moviedirectors

  validates :title, presence: true
  validates :description, presence: true
  validates :original_title, presence: true

end
