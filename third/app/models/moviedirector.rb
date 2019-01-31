class Moviedirector < ApplicationRecord
  belongs_to :movie
  belongs_to :director
end
