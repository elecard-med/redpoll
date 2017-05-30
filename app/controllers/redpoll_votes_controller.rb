class RedpollVotesController < ApplicationController
  unloadable
  include RedpollCommon
  before_action :check_vote_status
  before_filter :deny_access, :unless => :redpoll_group?, only: [:adminresult]
  layout :compute_layout
  def compute_layout
    action_name == "adminresult" ? "base" : "poll" 
  end
  def index
    if can_vote?
      @vote = RedpollVote.new
      @vote.user = User.current
    else
      @poll_result = RedpollVotesHelper.analize_redpoll(@redpoll_poll) if @redpoll_poll
      render action: "result"
    end
  end
  def vote    
    if can_vote?
      if RedpollVote.valid_vote_params?(@redpoll_poll, vote_params)
        RedpollVote.mass_create(@redpoll_poll.id, 
                                current_user.id,
                                vote_params, 
                                cookies[:_redmine_session])
        respond_to do |format|
          format.html { redirect_to redpoll_votes_path(@redpoll_poll)}
        end
      else
        flash[:error] = t('vote_error_msg') 
        respond_to do |format|
          format.html { redirect_to redpoll_votes_path(@redpoll_poll) }
        end
      end  
    else
    end
  end
  def resetpoll
    if !can_vote?
      RedpollVote.clear_poll_votes(@redpoll_poll.id, current_user.id)
    else
    end
    respond_to do |format|
      format.html { redirect_to redpoll_votes_path(@redpoll_poll)}
    end
  end
  def result
    @can_revote = false
    @poll_result = RedpollVotesHelper.analize_redpoll(@redpoll_poll) if @redpoll_poll
  end
  def adminresult
    add_breadcrumb t('polls'), redpoll_polls_path
    add_breadcrumb @redpoll_poll.title, edit_redpoll_poll_path(@redpoll_poll) 
    @can_revote = false
    @poll_result = RedpollVotesHelper.analize_redpoll(@redpoll_poll) if @redpoll_poll
  end
  def redpoll_poll_params
    params.require(:redpoll_poll_id)
  end
  def vote_params
    params.permit(:redpoll_vote)
    params[:redpoll_vote]
  end
  def can_vote?
    @can_vote
  end
  def check_vote_status
    @redpoll_poll = RedpollPoll.find(redpoll_poll_params)
    @can_vote = RedpollVote.can_vote?(@redpoll_poll, current_user.id)
    @can_revote = @redpoll_poll.active
  end
end
