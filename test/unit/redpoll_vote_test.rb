require File.expand_path('../../test_helper', __FILE__)
ActiveSupport::TestCase.fixture_path = File.expand_path("../../fixtures", __FILE__) 

class RedpollVoteTest < ActiveSupport::TestCase
  fixtures [:redpoll_polls, 
            :redpoll_questions, 
            :redpoll_variants,
            :redpoll_votes
  ]
  def test_votes_count
    assert_equal 9, RedpollVote.count
  end
  def test_vote_variant
    vote = RedpollVote.find(4)
    assert_equal 11, vote.redpoll_variant.id    
  end
  def test_delete_negative
    vote = RedpollVote.find(4)
    assert_equal true, vote.can_destroy?    
  end
end
