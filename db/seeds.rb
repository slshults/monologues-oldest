# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

Gender.create!(:name => 'Both')
Gender.create!(:name => 'Women')
Gender.create!(:name => 'Men')
Author.create!(:name => 'Shakespeare')
shake = Author.find_by_name('Shakespeare')
Play.create!(:title => 'Hamlet', :author_id => shake.id)
Play.create!(:title => 'Twelfth Night', :author_id => shake.id)