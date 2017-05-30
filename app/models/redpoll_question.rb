class RedpollQuestion < ActiveRecord::Base
  unloadable
  before_create :calc_position
  validates :val, presence: true
  belongs_to :redpoll_poll
  has_many :redpoll_variants
  attr_accessible :val, :position, :redpoll_poll_id
  default_scope { order(position: :asc) }
  def calc_position
    result = 0
    redpoll_poll.redpoll_questions.each do |quest|
      result = quest.position if result < quest.position
    end
    self.position = result + 1
  end
  def can_destroy?
    redpoll_variants.count == 0
  end
  def move_up
    if position > 1
      redpoll_poll.redpoll_questions.each do |quest|
        if quest.position == (self.position - 1)
          quest.position = self.position
          self.position = self.position - 1
          quest.save
          save
          break
        end
      end
    end
  end
  def move_down
    redpoll_poll.redpoll_questions.each do |quest|
      if (quest.position - 1) == self.position
        self.position = quest.position 
        quest.position = quest.position - 1
        quest.save
        save
        break
      end
    end
  end
end
