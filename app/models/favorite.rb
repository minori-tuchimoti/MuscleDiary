class Favorite < ApplicationRecord

  belongs_to :user
  belongs_to :muscle

  validates :user_id, uniqueness: {scope: :muscle_id}

end
