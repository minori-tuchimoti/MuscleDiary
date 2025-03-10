class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  devise authentication_keys: [:email] # ここを追加

  def admin?
    true # 管理者かどうかのロジックを記述
  end
  
end
