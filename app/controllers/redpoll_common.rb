module RedpollCommon
  extend ActiveSupport::Concern
  included do 
    rescue_from ActiveRecord::RecordNotFound do |exception|
      render_404 status: 404
    end
  end
  def current_user
    User.current
  end
  def redpoll_group?
    current_user.groups.named(Setting.plugin_redpoll['redpoll_group']) != []
  end
end
