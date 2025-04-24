class Public::UsersController < ApplicationController
  before_action :ensure_guest_user, only: [:edit]
  
  def index
    if current_user
      @user = current_user
    end
    @users = User.all
    @muscles = Muscle.all
    @newbook = Muscle.new
  end

  def show
    @user = User.find(params[:id])
    @muscle = Muscle.new
    @muscles = Muscle.where(user_id: @user.id)
    @newbook = Muscle.new
  end

  def edit
    @user = User.find(params[:id])
    if @user == current_user
        render "edit"
    else
      redirect_to user_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])
    Rails.logger.debug "Before update: #{@user.inspect}"
    if @user.update(user_params)
      Rails.logger.debug "After update: #{@user.inspect}"
      flash[:notice] = "You have updated user successfully."
      redirect_to user_path(current_user)
    else
      Rails.logger.debug "Update failed: #{@user.errors.full_messages}"
      render :edit
    end
  end

  def cancel
    @user = User.find(params[:id])
    if @user == current_user
      @user.destroy
      # ここで退会処理を実行し、ユーザーを削除するなどの操作を行います
      flash[:notice] = "退会が完了しました。ご利用ありがとうございました。"
      redirect_to root_path
    else
      flash[:alert] = "他のユーザーの退会はできません。"
      redirect_to user_path(current_user)
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "退会処理が完了しました。"
    redirect_to root_path
  end

  def liked_posts
    @liked_posts = Muscle.liked_posts(current_user, params[:page], 12)
  end

  private
  
  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end

  
  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest_user?
      redirect_to user_path(current_user) , notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end
end