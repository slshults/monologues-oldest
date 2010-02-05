class Monologue < ActiveRecord::Base
  belongs_to :gender
  belongs_to :author
  belongs_to :play

  validates_presence_of :play_id
  validates_presence_of :name

  validates_length_of :section, :maximum=>20
  validates_length_of :name, :maximum=>255
  validates_length_of :character, :maximum=>80
  validates_length_of :style, :maximum=>20
  validates_length_of :link, :maximum=>255


  attr_accessible :play_id, :section, :name, :body, :gender_id, :character, :style, :link
end
