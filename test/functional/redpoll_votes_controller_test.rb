require File.expand_path('../../test_helper', __FILE__)
ActiveSupport::TestCase.fixture_path = File.expand_path("../../fixtures", __FILE__) 

class RedpollVotesControllerTest < ActionController::TestCase
  fixtures [
    :redpoll_variants, 
    :redpoll_votes
  ]

  def set_redpoll_group status
    @controller.stubs(:redpoll_group?).returns(status)
  end
  def test_authorization_negative
    set_redpoll_group(false)
    poll = RedpollPoll.find(1)
    get :adminresult, redpoll_poll_id: poll
    assert_response :redirect
  end
  def test_authorization_positive
    set_redpoll_group(true)
    poll = RedpollPoll.find(1)
    get :adminresult, redpoll_poll_id: poll
    assert_response :success
    get :adminresult, redpoll_poll_id: 12345 
    assert_response :missing
  end
  def test_can_vote
    set_redpoll_group(true)
    get :index, redpoll_poll_id: 1234 
    assert_response :missing
    poll = RedpollPoll.find(1)
    get :index, redpoll_poll_id: poll
    assert_equal true, @controller.can_vote?
    poll = RedpollPoll.find(2)
    get :index, redpoll_poll_id: poll
    assert_equal false, @controller.can_vote?
  end
end
