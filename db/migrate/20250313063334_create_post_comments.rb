class CreatePostComments < ActiveRecord::Migration[6.1]
  def change
    create_table :post_comments do |t|
      t.integer :muscle_id
      t.integer :user_id
      t.integer :post_image_id
      t.text :comment
      t.timestamps
    end
  end
end
