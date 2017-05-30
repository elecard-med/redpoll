require File.expand_path('../../test_helper', __FILE__)
ActiveSupport::TestCase.fixture_path = File.expand_path("../../fixtures", __FILE__) 

class RedpollQuestionsControllerTest < ActionController::TestCase
  fixtures [
    :redpoll_polls, 
    :redpoll_questions
  ]
  def set_redpoll_group status
    @controller.stubs(:redpoll_group?).returns(status)
  end
  def test_authorization_negative
    set_redpoll_group(false)
    question = RedpollQuestion.find(1)
    get :index, redpoll_poll_id: question.redpoll_poll
    assert_response :redirect
    get :new, redpoll_poll_id: question.redpoll_poll
    assert_response :redirect
    get :edit, id: question
    assert_response :redirect
    patch :update, id: question
    assert_response :redirect
    delete :destroy, id: question
    assert_response :redirect
  end
  def test_index
    set_redpoll_group(true)
    question = RedpollQuestion.find(1)
    get :index, redpoll_poll_id: question.redpoll_poll
    assert_response :success
    get :index, redpoll_poll_id: 12345
    assert_response :missing
  end
  def test_new
    set_redpoll_group(true)
    question = RedpollQuestion.find(1)
    get :new, redpoll_poll_id: question.redpoll_poll
    assert_response :success
    get :new, redpoll_poll_id: 12345 
    assert_response :missing
  end
  def test_edit
    set_redpoll_group(true)
    question = RedpollQuestion.find(1)
    get :edit, id: question
    assert_response :success
    get :edit, id: 12345
    assert_response :missing
  end
end
