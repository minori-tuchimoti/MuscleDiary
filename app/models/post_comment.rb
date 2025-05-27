class PostComment < ApplicationRecord

  belongs_to :user
  belongs_to :muscle

  validates :comment, presence: true
end
