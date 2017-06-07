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
    adjust_percentage(final_result)
  end
  def self.adjust_percentage(data)
    data[:questions].each do |question|
      summary = question[1][:variants_summary]
      adjustment = 0.0
      summary.values.each do |variant|
        adjustment += variant[:percentage].to_f
      end
      adjustment = 100.00 - adjustment if adjustment > 0.0
      if !summary.empty?
        summary[summary.keys.last][:percentage] = (summary[summary.keys.last][:percentage].to_f + adjustment).round(2)  
      end 
    end
    data
  end
  def self.format_user(user)
    begin
      u = user.attributes.symbolize_keys
      black_list = [
          :hashed_password,
          :created_on
      ]
      black_list.each do |item| 
        u.delete(item)
      end
      Setting.plugin_redpoll['redpoll_user_format'] % u 
    rescue
      I18n.t('invalid_user_format')
    end
  end

end
