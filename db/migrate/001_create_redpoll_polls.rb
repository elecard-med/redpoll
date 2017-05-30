class CreateRedpollPolls < ActiveRecord::Migration
  def change
    create_table :redpoll_polls do |t|
      t.string :title
      t.string :description
      t.boolean :active
      t.integer :max_count
#      t.reference :redpoll_question
    end
  end
end
