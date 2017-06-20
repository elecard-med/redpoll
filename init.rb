require 'breadcrumbs_on_rails'
Redmine::Plugin.register :redpoll do
  name 'Redpoll plugin'
  author 'Elecard-Med Company (Aleksey Shimonchuk, Ivan Lysenko, Valery Dacyuk, Sergey Kochetkov)'
  author_url 'https://em70.ru/'
  description 'Plugin for creating polls'
  version '0.0.2'
  settings \
    :default =>
  {
    'redpoll_group'  => 'redpoll',
    'redpoll_user_format'  => '%{lastname} %{firstname}'
  },
  :partial => "settings/redpoll_settings"

  menu :top_menu, 
       :redpoll_polls,
       {
         :controller => 'redpoll_polls', :action => 'index'
       }, 
       :if => Proc.new { User.current.groups.named(Setting.plugin_redpoll['redpoll_group']) != [] },
       :caption => Proc.new { I18n.t('polls') }

  Redmine::WikiFormatting::Macros.register do
    desc "Insert redpoll" + "\n\n" +
      "{{redpoll(width height poll_id)}}"
    macro :redpoll do |obj, args|
        res = '<iframe  frameborder="0" style="border: 1px solid #ddd" width="' + args[0] +'" height="' + args[1] + '" src="//' + request.host_with_port + Redmine::Utils.relative_url_root + '/redpoll_votes/' + args[2] + '"></iframe>'
        res.html_safe
    end
  end
end
