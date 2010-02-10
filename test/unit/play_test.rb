require 'test_helper'

class PlayTest < ActiveSupport::TestCase
  test "valid play" do
    t = Play.create!(:title => 'Titanic', :author_id => 1, :classification => 'Tragedy')
    assert t.valid?
  end

    test "name must be unique" do
    t = Play.create!(:title => 'Titanic', :author_id => 1, :classification => 'Tragedy')
    assert t.valid?
    t2 = Play.create(:title => 'Titanic', :author_id => 1, :classification => 'Tragedy')
    assert t2.errors.on(:title)
  end

  test "must have author" do
    t = Play.create(:title => 'Titanic', :classification => 'Tragedy')
    assert !t.valid?
    assert t.errors.on(:author_id)
    t.author = authors(:shakespeare)
    assert_equal 'Shakespeare', t.author.name
    assert t.valid?
  end

  test "has valid classification" do
    t = Play.create(:title => 'Titanic', :author_id => authors(:shakespeare).id, :classification => 'Action')
    assert !t.valid?
    assert t.errors.on(:classification)
    t.classification = 'Comedy'
    assert t.valid?
    assert_equal 'Comedy', t.classification
  end

  test "must have classification" do
    t = Play.create(:title => 'Titanic', :author_id => authors(:shakespeare).id, :classification => nil)
    assert !t.valid?
    assert t.errors.on(:classification)
  end
end
