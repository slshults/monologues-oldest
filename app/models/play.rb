class Play < ActiveRecord::Base
  belongs_to :author
  has_many :monologues
  validates_presence_of :title
  validates_uniqueness_of :title
end
