class RedpollPoll < ActiveRecord::Base
  unloadable
  validates :title, presence: true
  attr_accessible :title, :active, :description
  has_many :redpoll_questions
  default_scope { order(id: :asc) }
  def can_destroy?
    redpoll_questions.count == 0
  end
end
