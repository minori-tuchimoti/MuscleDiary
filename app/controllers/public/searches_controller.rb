class Public::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]

    if @range == "User"
      @users = User.looks(params[:search], params[:word])
    else
      @muscles = Muscle.looks(params[:search], params[:word])
    end
  end
end
