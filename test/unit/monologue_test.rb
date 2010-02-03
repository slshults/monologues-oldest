require 'test_helper'

class MonologueTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Monologue.create(:name => 'foo', :play_id => 1).valid?
  end
end
