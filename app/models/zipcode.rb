##
# Class that represents a zipcode.
class Zipcode < ActiveRecord::Base
  belongs_to :metro

  def self.find_nearest_zip(latitude, longitude)
    lat = latitude.to_f
    lng = longitude.to_f
    if (lat != 0.0) && (lng != 0.0)
      result = Zipcode.select("zip").order(format("point(lat,long) <-> point(%f,%f) ASC", lat, lng)).first
      format("%05d", result.zip.to_i) if result
    end
  end
end
