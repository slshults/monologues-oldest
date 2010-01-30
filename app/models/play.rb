class Play < ActiveRecord::Base
  has_one :author
  has_many :monologues
end
