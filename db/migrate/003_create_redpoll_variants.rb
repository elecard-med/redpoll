class CreateRedpollVariants < ActiveRecord::Migration
  def change
    create_table :redpoll_variants do |t|
      t.string :val
      t.integer :redpoll_question_id
      t.integer :position
    end
  end
end
