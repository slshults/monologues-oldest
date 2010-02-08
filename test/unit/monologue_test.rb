require 'test_helper'

class MonologueTest < ActiveSupport::TestCase
  test "name must be unique" do
    t = Monologue.create!(:name => 'The monologue goes like this', :play_id => plays(:hamlet).id, :gender_id => genders(:men) )
    assert t.valid?
    t2 = Monologue.create(:name => 'The monologue goes like this', :play_id => plays(:hamlet).id, :gender_id => genders(:men) )
    assert t2.errors.on(:name)
  end

  test "has play and author" do
    assert_equal 'Hamlet', monologues(:to_be_or_not_to_be).play.title
    assert_equal 'Shakespeare', monologues(:to_be_or_not_to_be).play.author.name
  end

end
