class Play < ActiveRecord::Base
  has_one :author
  has_many :monologues
  validates_uniqueness_of :title
end
