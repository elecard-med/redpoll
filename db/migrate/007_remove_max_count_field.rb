class RemoveMaxCountField < ActiveRecord::Migration
  def change
    remove_column :redpoll_polls, :max_count, :integer
  end
end
