#---
# Excerpted from "Rails Test Prescriptions",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/nrtest for more book information.
#---
class User < ActiveRecord::Base
  validates_uniqueness_of :email
  validates_presence_of :email
  validates_presence_of :name
  validates_presence_of :password


  def self.authenticate(email, password)
    user = self.find_by_email(email)
    if user
      if user.password != password
        user = nil
      end
    end
    user
  end
end
