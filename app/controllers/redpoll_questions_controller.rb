class RedpollQuestionsController < ApplicationController
  unloadable
  include RedpollCommon
  before_action :set_redpoll_question, only: [
    :edit, 
    :update, 
    :destroy, 
    :cascade_delete_confirm,
    :cascade_delete  
  ]
  before_action :set_moving_question, only: [
    :up_position,
    :down_position
  ]
  before_action :set_current_poll, only: [:index, :new]
  before_filter :deny_access, :unless => :redpoll_group?
  def index
     add_breadcrumb t('polls'), redpoll_polls_path
     add_breadcrumb @redpoll_poll.title, edit_redpoll_poll_path(@redpoll_poll)
     add_breadcrumb t('questions'), redpoll_questions_path
  end
  def new
     add_breadcrumb t('polls'), redpoll_polls_path
     add_breadcrumb @redpoll_poll.title, edit_redpoll_poll_path(@redpoll_poll)
     add_breadcrumb t('questions'), redpoll_questions_path
     add_breadcrumb t('create_redpoll_question'), new_redpoll_question_path
  end
  def edit
     add_breadcrumb t('polls'), redpoll_polls_path
     add_breadcrumb @redpoll_question.redpoll_poll.title, edit_redpoll_poll_path(@redpoll_question.redpoll_poll) 
     add_breadcrumb t('questions'), redpoll_questions_path(@redpoll_question.redpoll_poll)
     add_breadcrumb t('edit_redpoll_question'), edit_redpoll_question_path
  end
  def create
    bf_create RedpollQuestion.new(redpoll_question_params)
  end
  def update
    bf_update @redpoll_question, redpoll_question_params
  end
  def up_position
    @redpoll_question.move_up
    respond_to do |format|
      format.html { redirect_to redpoll_questions_path(@redpoll_question.redpoll_poll)}
    end
  end
  def down_position
    @redpoll_question.move_down
    respond_to do |format|
      format.html { redirect_to redpoll_questions_path(@redpoll_question.redpoll_poll)}
    end
  end
  def destroy
    bf_destroy @redpoll_question
  end
  def cascade_delete_confirm
  end
  def cascade_delete
    bf_cascade_delete @redpoll_question
  end
  #=========================================
  def bf_create entity
    respond_to do |format|
      if entity.save
        flash[:notice] = t('success_create')
        #format.html { redirect_to action: "index" }
        format.html { redirect_to redpoll_questions_path(entity.redpoll_poll)}
        format.json { render :show, status: :created, location: entity }
      else
        @redpoll_question = entity
        redpoll_poll = @redpoll_question.redpoll_poll
        add_breadcrumb t('polls'), redpoll_polls_path
        add_breadcrumb redpoll_poll.title, edit_redpoll_poll_path(redpoll_poll)
        add_breadcrumb t('questions'), redpoll_questions_path
        add_breadcrumb t('create_redpoll_question'), new_redpoll_question_path
        format.html { render :new }
        format.json { render json: entity.errors, status: :unprocessable_entity }
      end
    end
  end
  def bf_update entity, params
    respond_to do |format|
      if entity.update(params)
        flash[:notice] = t('success_update')
        format.html { redirect_to redpoll_questions_path(entity.redpoll_poll)}
        format.json { render :show, status: :ok, location: entity }
      else
        @redpoll_question = entity
        redpoll_poll = @redpoll_question.redpoll_poll
        add_breadcrumb t('polls'), redpoll_polls_path
        add_breadcrumb redpoll_poll.title, edit_redpoll_poll_path(redpoll_poll)
        add_breadcrumb t('questions'), redpoll_questions_path(@redpoll_question.redpoll_poll)
        add_breadcrumb t('edit_redpoll_question'), edit_redpoll_question_path
        format.html { render :edit}
        format.json { render json: entity.errors, status: :unprocessable_entity }
      end
    end
  end
  def bf_destroy entity
    if entity.can_destroy?
      entity.destroy
      respond_to do |format|
        flash[:notice] = t('success_delete')
        format.html { redirect_to redpoll_questions_path(entity.redpoll_poll)}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to action: "cascade_delete_confirm" }
      end  
    end
  end
  def bf_cascade_delete entity
    entity.destroy
    respond_to do |format|
      flash[:notice] = t('success_delete')
      format.html { redirect_to redpoll_questions_path(entity.redpoll_poll)}
      format.json { head :no_content }
    end
  end
  #=========================================
  private
  def set_redpoll_question
    @redpoll_question = RedpollQuestion.find(params[:id])
  end
  def set_moving_question
    @redpoll_question = RedpollQuestion.find(params[:redpoll_question_id])
  end
  def set_current_poll
    @redpoll_poll = RedpollPoll.find(redpoll_poll_params)
    @redpoll_questions = @redpoll_poll.redpoll_questions
    @redpoll_question = RedpollQuestion.new
    @redpoll_question.redpoll_poll = @redpoll_poll
  end
  def redpoll_poll_params
    params.require(:redpoll_poll_id)
  end
  def redpoll_question_params
    params.require(:redpoll_question).permit(:val, :redpoll_poll_id)
  end
end
