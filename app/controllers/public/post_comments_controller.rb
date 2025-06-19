class Public::PostCommentsController < ApplicationController
  def create
    @muscle = Muscle.find(params[:muscle_id])
    @post_comment = current_user.post_comments.new(post_comment_params)
    @post_comment.muscle_id = @muscle.id
  
    if @post_comment.save
      redirect_to muscle_path(@muscle), notice: 'コメントを投稿しました'
    else
      @user = @muscle.user
      # ページネーションつきで再取得する
      @post_comments = @muscle.post_comments.includes(:user).order(created_at: :desc).page(params[:page]).per(5)
      flash.now[:alert] = 'コメントを入力してください'
      render 'public/muscles/show'
    end
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
