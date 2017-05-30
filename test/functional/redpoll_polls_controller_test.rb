require File.expand_path('../../test_helper', __FILE__)
ActiveSupport::TestCase.fixture_path = File.expand_path("../../fixtures", __FILE__) 

class RedpollPollsControllerTest < ActionController::TestCase
  fixtures :redpoll_polls
  def set_redpoll_group status
    @controller.stubs(:redpoll_group?).returns(status)
  end
  def test_authorization_negative
    set_redpoll_group(false)
    poll = RedpollPoll.find(1)
    get :index
    assert_response :redirect
    get :show, id: poll
    assert_response :redirect
    get :new
    assert_response :redirect
    get :edit, id: poll
    assert_response :redirect
    patch :update, id: poll
    assert_response :redirect
    delete :destroy, id: poll
    assert_response :redirect
  end
  def test_index
    set_redpoll_group(true)
    get :index
    assert_response :success
  end
  def test_show
    set_redpoll_group(true)
    poll = RedpollPoll.find(1)
    get :show, id: poll
    assert_response :missing
  end
  def test_new
    set_redpoll_group(true)
    get :new
    assert_response :success
  end
  def test_edit
    set_redpoll_group(true)
    poll = RedpollPoll.find(1)
    get :edit, id: poll
    assert_response :success
    get :edit, id: 12345 
    assert_response :missing
  end
end
