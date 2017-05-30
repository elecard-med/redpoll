class CreateRedpollVotes < ActiveRecord::Migration
  def change
    create_table :redpoll_votes do |t|
      t.integer :user_id
      t.integer :redpoll_variant_id
      t.string :cookie
    end
  end
end
