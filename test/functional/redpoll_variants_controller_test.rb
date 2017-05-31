require File.expand_path('../../test_helper', __FILE__)
ActiveSupport::TestCase.fixture_path = File.expand_path("../../fixtures", __FILE__) 
class RedpollVariantsControllerTest < ActionController::TestCase
  fixtures [
    :redpoll_variants, 
    :redpoll_questions
  ]
  def set_redpoll_group status
    @controller.stubs(:redpoll_group?).returns(status)
  end
  def test_authorization_negative
    set_redpoll_group(false)
    variant = RedpollVariant.find(1)
    get :index, redpoll_question_id: variant.redpoll_question
    assert_response :redirect
    get :new, redpoll_question_id: variant.redpoll_question
    assert_response :redirect
    get :edit, id: variant
    assert_response :redirect
    patch :update, id: variant
    assert_response :redirect
    delete :destroy, id: variant
    assert_response :redirect
    get :cascade_delete, id: variant
    assert_response :redirect
    delete :cascade_delete, id: variant
    assert_response :redirect
    get :cascade_delete_confirm, id: variant
    assert_response :redirect
  end
  def test_index
    set_redpoll_group(true)
    variant = RedpollVariant.find(1)
    get :index, redpoll_question_id: variant.redpoll_question
    assert_response :success
    get :index, redpoll_question_id: 12345 
    assert_response :missing
  end
  def test_new
    set_redpoll_group(true)
    variant = RedpollVariant.find(1)
    get :new, redpoll_question_id: variant.redpoll_question
    assert_response :success
    get :new, redpoll_question_id: 12345 
    assert_response :missing
  end
  def test_edit
    set_redpoll_group(true)
    variant = RedpollVariant.find(1)
    get :edit, id: variant
    assert_response :success
    get :edit, id: 12345 
    assert_response :missing
  end
  def test_cascade_delete_confirm
    set_redpoll_group(true)
    variant = RedpollVariant.find(1)
    get :cascade_delete_confirm, id: variant
    assert_response :success
    get :cascade_delete_confirm, id: 12345 
    assert_response :missing
    get :cascade_delete, id: 12345 
    assert_response :missing
  end

end
