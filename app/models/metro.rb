##
# Model that represents a metro - a collection of zipcodes around a major
# city.
class Metro < ActiveRecord::Base
  has_many :zipcodes
end
