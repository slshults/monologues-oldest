class Gender < ActiveRecord::Base
  has_many :monologues
  validates_presence_of :name
end
