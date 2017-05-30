require File.expand_path('../../test_helper', __FILE__)
ActiveSupport::TestCase.fixture_path = File.expand_path("../../fixtures", __FILE__) 
class RedpollPollTest < ActiveSupport::TestCase
  fixtures [:redpoll_polls, 
            :redpoll_questions, 
            :redpoll_variants,
            :redpoll_votes
  ]
  def test_polls_count
    assert_equal 3, RedpollPoll.count
  end
  def test_poll_questions
    poll = RedpollPoll.find(1)
    assert_equal 3, poll.redpoll_questions.count
  end
  def test_delete_negative
    poll = RedpollPoll.find(1)
    assert_equal false, poll.can_destroy?
  end
  def test_delete_positive
    poll = RedpollPoll.find(1)
    questions = poll.redpoll_questions
    questions.each do |question|
      question.redpoll_variants.each do |variant|
        variant.redpoll_votes.each do |vote|
          vote.destroy
        end 
        variant.destroy
      end
      question.destroy
    end
    assert_equal true, poll.can_destroy?
  end
end
