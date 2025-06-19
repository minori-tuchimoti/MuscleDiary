class Public::MusclesController < ApplicationController
  devise_group :user, contains: [:user]

  def index
    @user = current_user if current_user
    @muscles = Muscle.order(created_at: :desc).page(params[:page]).per(10)  # 新しい順に並べる
    @new_muscle = Muscle.new
  end

  def show
    @newbook = Muscle.new
    @muscle = Muscle.find(params[:id])
    @user = @muscle.user
    @post_comment = PostComment.new
    @post_comments = @muscle.post_comments.includes(:user).order(created_at: :desc).page(params[:page]).per(5)
  end

  def create
    @muscle = Muscle.new(muscle_params)
    @muscle.user_id = current_user.id
    if @muscle.save
      flash[:notice]="You have creatad book successfully."
      redirect_to muscle_path(@muscle)
    else
      flash[:alert] = @muscle.errors.full_messages.join("activerecord.errors.models.msucle.")
      @user = current_user
      @muscles = Muscle.all
      @newbook = Muscle.new
      @users = User.all
      render 'index'
    end
  end

  def edit
    @muscle = Muscle.find(params[:id])
    if @muscle.user == current_user
        render "edit"
    else
        redirect_to muscles_path
    end
  end

  def update
      @muscle = Muscle.find(params[:id])
      @muscle.assign_attributes(muscle_params)
    
      if @muscle.valid?
        @muscle.save
        flash[:notice] = "Muscle was successfully updated."
        redirect_to muscle_path(@muscle.id)
      else
        flash.now[:alert] = @muscle.errors.full_messages.join(". ")
        render :edit
      end
  end

  def destroy
    @muscle = Muscle.find(params[:id])
    if @muscle.destroy
      flash[:notice]="Muscle was successfully destroyed."
      redirect_to muscles_path
    end
  end

  def self.liked_muscles(user, page, per_page)
    includes(:muscle_favorites) 
      .where(muscle_favorites: { user_id: user.id })
      .order(created_at: :desc)
      .page(page) 
      .per(per_page) 
  end

  private

  def muscle_params
    params.require(:muscle).permit(:title, :body)
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end