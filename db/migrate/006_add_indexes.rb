class AddIndexes < ActiveRecord::Migration
  def change
    add_index :redpoll_votes, :user_id
    add_index :redpoll_votes, :redpoll_variant_id
    add_index :redpoll_variants, :redpoll_question_id
    add_index :redpoll_questions, :redpoll_poll_id
  end
end
