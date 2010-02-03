class Author < ActiveRecord::Base
  has_many :plays
  validates_presence_of :name
end
