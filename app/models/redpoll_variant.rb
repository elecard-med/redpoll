class RedpollVariant < ActiveRecord::Base
  unloadable
  before_create :calc_position
  belongs_to :redpoll_question
  validates :val, presence: true
  has_many :redpoll_votes
  attr_accessible :val, :position, :redpoll_question_id
  default_scope { order(position: :asc) }
  def can_destroy?
    redpoll_votes.count == 0
  end
  def calc_position
    result = 0
    redpoll_question.redpoll_variants.each do |v|
      result = v.position if result < v.position
    end
    self.position = result + 1
  end
  def move_up
    if position > 1
      redpoll_question.redpoll_variants.each do |v|
        if v.position == (self.position - 1)
          v.position = self.position
          self.position = self.position - 1
          v.save
          save
          break
        end
      end
    end
  end
  def move_down
    redpoll_question.redpoll_variants.each do |v|
      if (v.position - 1) == self.position
        self.position = v.position 
        v.position = v.position - 1
        v.save
        save
        break
      end
    end
  end
end
