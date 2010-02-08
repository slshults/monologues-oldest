require 'test_helper'

class PlayTest < ActiveSupport::TestCase
  test "name must be unique" do
    t = Play.create!(:title => 'Titanic', :author_id => 1)
    assert t.valid?
    t2 = Play.create(:title => 'Titanic', :author_id => 1)
    assert t2.errors.on(:title)
  end

  test "has author" do
    s = Author.find_by_name('Shakespeare')
    t = Play.create!(:title => 'Titanic', :author_id => s.id)
    assert_equal 'Shakespeare', t.author.name
  end

end
