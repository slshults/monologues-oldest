require 'test_helper'

class AuthorTest < ActiveSupport::TestCase
  test "valid author" do
    author = Author.create!(:name => 'Christopher Marlowe')
    assert author.valid?
  end

  test "author name must be unique" do
    author = Author.create!(:name => 'Christopher Marlowe')
    assert author.valid?
    author = Author.create(:name => 'Christopher Marlowe')
    assert author.errors.on(:name)
  end
end
