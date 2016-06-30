class Term < ActiveRecord::Base
  validates :version, presence: true
end
