class RedpollVote < ActiveRecord::Base
  unloadable
  attr_accessible :user
  attr_accessible :cookie
  belongs_to :user
  belongs_to :redpoll_variant

  def self.mass_create(poll_id, user_id, vote_params, redmine_session_cookie)
    clear_poll_votes(poll_id, user_id)
    vote_params[:poll_result].values.each do |variant_id|
      RedpollVote.create({
        cookie: redmine_session_cookie, 
        user_id:  user_id,
        redpoll_variant_id: variant_id
      }, without_protection: true)
    end
  end
  def can_destroy?
    true
  end
  def self.valid_vote_params?(poll, vote_params)
    result = false
    if vote_params[:poll_result]
      result = true
      poll.redpoll_questions.each do |q|
        if !vote_params[:poll_result].has_key?("#{q.id}")
          result = false
        end
      end
    end
    result
  end
  def self.can_vote?(poll, user_id)
    result = false
    if poll.active
      result = true
      users_votes = RedpollVote.where(user_id: user_id).all
      users_votes.each do |user_vote|
        variant = RedpollVariant.find(user_vote.redpoll_variant_id)
        if (variant.redpoll_question.redpoll_poll.id == poll.id)
          result = false
        end
      end
    end
    result
  end
  def self.clear_poll_votes(poll_id, user_id)
    users_votes = RedpollVote.where(user_id: user_id).all
    users_votes.each do |user_vote|
      variant = RedpollVariant.find(user_vote.redpoll_variant_id)
      if (variant.redpoll_question.redpoll_poll.id == poll_id)
        user_vote.destroy
      end
    end
  end
end
