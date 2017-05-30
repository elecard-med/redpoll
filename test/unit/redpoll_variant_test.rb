require File.expand_path('../../test_helper', __FILE__)
ActiveSupport::TestCase.fixture_path = File.expand_path("../../fixtures", __FILE__) 

class RedpollVariantTest < ActiveSupport::TestCase
  fixtures [:redpoll_polls, 
            :redpoll_questions, 
            :redpoll_variants,
            :redpoll_votes
  ]

  def test_variants_count
    assert_equal 27, RedpollVariant.count
  end
  def test_variant_votes
    variant = RedpollVariant.find(1)
    assert_equal 1, variant.redpoll_votes.count    
  end
  def test_variant_question
    variant = RedpollVariant.find(17)
    assert_equal 6, variant.redpoll_question.id    
  end
  def test_delete_negative
    variant = RedpollVariant.find(4)
    assert_equal false, variant.can_destroy?    
  end
  def test_delete_positive
    variant = RedpollVariant.find(4)
      variant.redpoll_votes.each do |vote|
        vote.destroy
      end 
    assert_equal true, variant.can_destroy?
  end
end
