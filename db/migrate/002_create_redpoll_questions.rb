class CreateRedpollQuestions < ActiveRecord::Migration
  def change
    create_table :redpoll_questions do |t|
      t.string :val
      t.integer :redpoll_poll_id
      t.integer :position
    end
  end
end
