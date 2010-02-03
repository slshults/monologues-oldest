class Play < ActiveRecord::Base
  has_one :author
  has_many :monologues
  validates_presence_of :title
  validates_uniqueness_of :title
end
