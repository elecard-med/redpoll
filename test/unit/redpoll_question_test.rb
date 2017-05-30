require File.expand_path('../../test_helper', __FILE__)
ActiveSupport::TestCase.fixture_path = File.expand_path("../../fixtures", __FILE__) 
class RedpollQuestionTest < ActiveSupport::TestCase
  fixtures [:redpoll_polls, 
            :redpoll_questions, 
            :redpoll_variants,
            :redpoll_votes
  ]
  def test_questions_count
    assert_equal 9, RedpollQuestion.count
  end
  def test_question_variants
    question = RedpollQuestion.find(1)
    assert_equal 3, question.redpoll_variants.count    
  end
  def test_question_poll
    question = RedpollQuestion.find(4)
    assert_equal 2, question.redpoll_poll.id    
  end
  def test_delete_negative
    question = RedpollQuestion.find(4)
    assert_equal false, question.can_destroy?    
  end
  def test_delete_positive
    question = RedpollQuestion.find(4)
    question.redpoll_variants.each do |variant|
      variant.redpoll_votes.each do |vote|
        vote.destroy
      end 
      variant.destroy
    end
    assert_equal true, question.can_destroy?
  end
end
