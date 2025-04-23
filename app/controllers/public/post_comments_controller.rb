class Public::PostCommentsController < ApplicationController
  def create
    muscle = Muscle.find(params[:muscle_id])
    comment = current_user.post_comments.new(post_comment_params)
    comment.muscle_id = muscle.id
    comment.save
    redirect_to muscle_path(muscle)
  end

  def destroy
    @muscle = Muscle.find(params[:muscle_id])
    @post_comment = @muscle.post_comments.find(params[:id])
    
    if current_user == @post_comment.user
      @post_comment.destroy
      redirect_to muscle_path(@muscle), notice: 'コメントを削除しました'
    else
      redirect_to muscle_path(@muscle), alert: '他のユーザーのコメントは削除できません'
    end
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
