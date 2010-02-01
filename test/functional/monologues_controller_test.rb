require 'test_helper'

class MonologuesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Monologue.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Monologue.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Monologue.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to monologue_url(assigns(:monologue))
  end
  
  def test_edit
    get :edit, :id => Monologue.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Monologue.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Monologue.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Monologue.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Monologue.first
    assert_redirected_to monologue_url(assigns(:monologue))
  end
  
  def test_destroy
    monologue = Monologue.first
    delete :destroy, :id => monologue
    assert_redirected_to monologues_url
    assert !Monologue.exists?(monologue.id)
  end
end
