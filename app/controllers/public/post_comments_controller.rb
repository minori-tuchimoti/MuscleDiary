class Public::PostCommentsController < ApplicationController
  def create
    muscle = Muscle.find(params[:muscle_id])
    comment = current_user.post_comments.new(post_comment_params)
    comment.muscle_id = muscle.id
    comment.save
    redirect_to muscle_path(muscle)
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
