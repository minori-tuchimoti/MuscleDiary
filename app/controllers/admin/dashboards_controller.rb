class Admin::DashboardsController < ApplicationController
  layout 'admin' # ここを追加
  before_action :authenticate_admin!
  def index
      @users = User.all
  end
end
