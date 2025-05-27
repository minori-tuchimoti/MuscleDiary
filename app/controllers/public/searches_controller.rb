class Public::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @model = params[:model]  # :modelを受け取る
    @content = params[:content]  # :contentを受け取る
    @method = params[:method]  # :methodを受け取る
    
    if @model == 'user'
      @records = User.search_for(@content, @method)
    else
      @records = Muscle.search_for(@content, @method)
    end
  end
end