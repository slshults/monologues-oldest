class Monologue < ActiveRecord::Base
  belongs_to :gender
  belongs_to :author
  belongs_to :play
  attr_accessible :play_id, :section, :name, :body, :gender_id, :character, :style, :link
  validates_presence_of :play_id
  validates_presence_of :name
end
