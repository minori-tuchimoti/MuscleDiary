class Admin::DashboardsController < ApplicationController
  layout 'admin' # ここを追加
  def index
      @users = User.all
  end
end
