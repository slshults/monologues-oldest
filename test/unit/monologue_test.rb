require 'test_helper'

class MonologueTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Monologue.new.valid?
  end
end
