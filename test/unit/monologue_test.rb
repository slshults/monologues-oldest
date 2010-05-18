require 'test_helper'

class MonologueTest < ActiveSupport::TestCase
  test "valid monologue" do
    t = Monologue.create(
        :first_line => 'The monologue goes like this',
        :play_id => plays(:hamlet).id,
        :gender_id => genders(:men),
        :pdf_link => 'http://shake.com/hamlet.pdf',
        :body_link => 'http://shake.com/hamletIi1.htm',
        :location => 'I i 1',
        :intercut => 1,
        :character => 'Hamlet',
        :body => "How now brown cow" * 2048
      )
    assert t.valid?
    assert t.errors.full_messages.empty?
    assert_equal 'Hamlet', t.play.title
    assert_equal 'Shakespeare', t.play.author.name
    assert_equal '- intercut', t.intercut_label
    assert_equal 'Hamlet', t.character
  end

  test "first_line must be unique within play" do
    t = Monologue.create(:first_line => 'The monologue goes like this', :play_id => plays(:hamlet).id, :gender_id => genders(:men) )
    assert t.valid?
    t2 = Monologue.create(:first_line => 'The monologue goes like this', :play_id => plays(:hamlet).id, :gender_id => genders(:men) )
    assert t2.errors.on(:first_line)
    t2.play_id = plays(:macbeth).id
    assert t2.valid?
  end

  test "has play and author" do
    assert_equal 'Hamlet', monologues(:to_be_or_not_to_be).play.title
    assert_equal 'Shakespeare', monologues(:to_be_or_not_to_be).play.author.name
  end

end
