class AddMuscleIdToPostComments < ActiveRecord::Migration[6.1]
  def change
    add_reference :post_comments, :muscle, null: false, foreign_key: true
  end
end
