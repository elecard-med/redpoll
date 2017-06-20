class RemoveCookieField < ActiveRecord::Migration
  def change
    remove_column :redpoll_votes, :cookie, :string
  end
end
