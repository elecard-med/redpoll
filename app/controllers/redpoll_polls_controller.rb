class RedpollPollsController < ApplicationController
  unloadable
  include RedpollCommon
  before_action :set_redpoll_poll, only: [:edit, :update, :destroy]
  before_filter :deny_access, :unless => :redpoll_group?
  def index
    @redpoll_polls = RedpollPoll.all
  end
  def show
  end
  def new
    add_breadcrumb t('polls'), redpoll_polls_path
    add_breadcrumb t('create_redpoll_poll'), new_redpoll_poll_path
    @redpoll_poll = RedpollPoll.new
    @redpoll_poll.active = true
  end
  def edit
    add_breadcrumb t('polls'), redpoll_polls_path
    add_breadcrumb t('edit_redpoll_poll'), edit_redpoll_poll_path
  end
  def create
    bf_create RedpollPoll.new(redpoll_poll_params)
  end
  def update
    bf_update @redpoll_poll, redpoll_poll_params
  end
  def destroy
    bf_destroy @redpoll_poll
  end
  #=========================================
  def bf_create entity
    respond_to do |format|
      if entity.save
        flash[:notice] = t('success_create')
        format.html { redirect_to action: "index" }
        format.json { render :show, status: :created, location: entity }
      else
        @redpoll_poll = entity
        add_breadcrumb t('polls'), redpoll_polls_path
        add_breadcrumb t('create_redpoll_poll'), new_redpoll_poll_path
        format.html { render :new }
        format.json { render json: entity.errors, status: :unprocessable_entity }
      end
    end
  end
  def bf_update entity, params
    respond_to do |format|
      if entity.update(params)
        flash[:notice] = t('success_update')
        format.html { redirect_to action: "index" }
        format.json { render :show, status: :ok, location: entity }
      else
        @redpoll_poll = entity
        add_breadcrumb t('polls'), redpoll_polls_path
        add_breadcrumb t('edit_redpoll_poll'), edit_redpoll_poll_path
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
        format.html { redirect_to action: "index" }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        flash[:error] = t('fail_delete')
        format.html { redirect_to action: "index" }
      end  
    end
  end
  #=========================================
  private
  def set_redpoll_poll
    @redpoll_poll = RedpollPoll.find(params[:id])
  end
  def redpoll_poll_params
    params.require(:redpoll_poll).permit(:title, :description, :active)
  end
end
