class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  private
  def authenticate_user!
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end
end
