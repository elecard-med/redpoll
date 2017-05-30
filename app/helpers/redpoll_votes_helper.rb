module RedpollVotesHelper
  class VoteCalculator
    def self.total_calc(poll)
      res = 0
      if !poll.redpoll_questions.empty?
        poll.redpoll_questions[0].redpoll_variants.each do |variant|
          res +=  RedpollVote.where(redpoll_variant_id: variant.id).all.count
        end
      end
      res
    end
    def self.calc_percentage(total, actual)
     res = "0" 
      if total > 0
        res = ((actual * 100.0) / total).round(2)
      end
     res
    end
  end
  def self.analize_redpoll(redpoll_poll)
    questions_result = Hash.new 
    total_counter = VoteCalculator.total_calc(redpoll_poll)
    redpoll_poll.redpoll_questions.each do |question|
      variants_summary = Hash.new  
      question.redpoll_variants.each do |variant|
        actual_count =  RedpollVote.where(redpoll_variant_id: variant.id).all.count
        variants_summary[variant.id] = {
          counter: actual_count, 
          percentage: VoteCalculator.calc_percentage(total_counter, actual_count)
        }
      end    
      questions_result[question.id] = { 
        total_counter: total_counter, 
        variants_summary: variants_summary,
      }
    end
    final_result = Hash.new
    final_result[:questions] = questions_result
    final_result[:total_votes] = total_counter
    final_result
  end
  def self.format_user(user)
    begin
      Setting.plugin_redpoll['redpoll_user_format'] % user.attributes.symbolize_keys
    rescue
      I18n.t('invalid_user_format')
    end
  end

end
