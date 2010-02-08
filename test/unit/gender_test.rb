require 'test_helper'

class GenderTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "must be unique" do
    ms = Gender.create!(:name => 'MetroSexual')
    assert ms.valid?
    ms2 = Gender.create(:name => 'MetroSexual')
    assert ms2.errors.on(:name)
  end
end
