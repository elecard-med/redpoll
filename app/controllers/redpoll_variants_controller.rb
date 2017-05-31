class RedpollVariantsController < ApplicationController
  unloadable
  include RedpollCommon
  before_action :set_redpoll_variant, only: [
    :edit, 
    :update, 
    :destroy,
    :cascade_delete_confirm,
    :cascade_delete
  ]
  before_action :set_current_question, only: [:index, :new]
  before_filter :deny_access, :unless => :redpoll_group?
  before_action :set_moving_question, only: [
    :up_position,
    :down_position
  ]
  def index
     add_breadcrumb t('polls'), redpoll_polls_path
     add_breadcrumb @redpoll_question.redpoll_poll.title, edit_redpoll_poll_path(@redpoll_question.redpoll_poll) 
     add_breadcrumb t('questions'), redpoll_questions_path(@redpoll_question.redpoll_poll)
     add_breadcrumb @redpoll_question.val, edit_redpoll_question_path(@redpoll_question) 
     add_breadcrumb t('variants'), redpoll_variants_path
  end
  def new
     add_breadcrumb t('polls'), redpoll_polls_path
     add_breadcrumb @redpoll_question.redpoll_poll.title, edit_redpoll_poll_path(@redpoll_question.redpoll_poll) 
     add_breadcrumb t('questions'), redpoll_questions_path(@redpoll_question.redpoll_poll)
     add_breadcrumb @redpoll_question.val, edit_redpoll_question_path(@redpoll_question) 
     add_breadcrumb t('create_redpoll_variant'), new_redpoll_variant_path
  end
  def edit
     redpoll_question = @redpoll_variant.redpoll_question
     add_breadcrumb t('polls'), redpoll_polls_path
     add_breadcrumb redpoll_question.redpoll_poll.title, edit_redpoll_poll_path(redpoll_question.redpoll_poll)
     add_breadcrumb t('questions'), redpoll_questions_path(redpoll_question.redpoll_poll)
     add_breadcrumb redpoll_question.val, edit_redpoll_question_path(redpoll_question) 
     add_breadcrumb t('edit_redpoll_variant'), edit_redpoll_variant_path
  end
  def create
    bf_create RedpollVariant.new(redpoll_variant_params)
  end
  def update
    bf_update @redpoll_variant, redpoll_variant_params
  end
  def destroy
    bf_destroy @redpoll_variant
  end
  def cascade_delete_confirm
  end
  def cascade_delete
    bf_cascade_delete @redpoll_variant
  end
  def up_position
    @redpoll_variant.move_up
    respond_to do |format|
      format.html { redirect_to redpoll_variants_path(@redpoll_variant.redpoll_question)}
    end
  end
  def down_position
    @redpoll_variant.move_down
    respond_to do |format|
      format.html { redirect_to redpoll_variants_path(@redpoll_variant.redpoll_question)}
    end
  end
  #=========================================
  def bf_create entity
    respond_to do |format|
      if entity.save
        flash[:notice] = t('success_create')
        format.html { redirect_to redpoll_variants_path(entity.redpoll_question)}
        format.json { render :show, status: :created, location: entity }
      else
        @redpoll_variant = entity
        add_breadcrumb t('polls'), redpoll_polls_path
        add_breadcrumb @redpoll_question.redpoll_poll.title, edit_redpoll_poll_path(@redpoll_question.redpoll_poll) 
        add_breadcrumb t('questions'), redpoll_questions_path(@redpoll_question.redpoll_poll)
        add_breadcrumb @redpoll_question.val, edit_redpoll_question_path(@redpoll_question) 
        add_breadcrumb t('create_redpoll_variant'), new_redpoll_variant_path
        format.html { render :new }
        format.json { render json: entity.errors, status: :unprocessable_entity }
      end
    end
  end
  def bf_update entity, params
    respond_to do |format|
      if entity.update(params)
        flash[:notice] = t('success_update')
        format.html { redirect_to redpoll_variants_path(entity.redpoll_question)}
        format.json { render :show, status: :ok, location: entity }
      else
        @redpoll_variant = entity
        add_breadcrumb t('polls'), redpoll_polls_path
        add_breadcrumb @redpoll_question.redpoll_poll.title, edit_redpoll_poll_path(@redpoll_question.redpoll_poll) 
        add_breadcrumb t('questions'), redpoll_questions_path(@redpoll_question.redpoll_poll)
        add_breadcrumb @redpoll_question.val, edit_redpoll_question_path(@redpoll_question) 
        add_breadcrumb t('edit_redpoll_variant'), edit_redpoll_variant_path
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
        format.html { redirect_to redpoll_variants_path(entity.redpoll_question)}
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
      format.html { redirect_to redpoll_variants_path(entity.redpoll_question)}
      format.json { head :no_content }
    end
  end
  #=========================================
  private
  def set_moving_question
    @redpoll_variant = RedpollVariant.find(params[:redpoll_variant_id])
  end
  def set_redpoll_variant
    @redpoll_variant = RedpollVariant.find(params[:id])
  end
  def set_current_question
    @redpoll_question = RedpollQuestion.find(redpoll_question_params)
    @redpoll_variants = @redpoll_question.redpoll_variants
    @redpoll_variant = RedpollVariant.new
    @redpoll_variant.redpoll_question = @redpoll_question
  end
  def redpoll_question_params
    params.require(:redpoll_question_id)
  end
  def redpoll_variant_params
    params.require(:redpoll_variant).permit(:val, :redpoll_question_id)
  end
end
