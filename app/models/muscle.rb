class Muscle < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :post_comments, dependent: :destroy

  validates :body, length: { maximum: 200 }

  validates :title, presence: true
  validates :body, presence: true

  def self.looks(search, word)
    if search == "perfect_match"
      @muscle = Muscle.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Muscle.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @muscle = Muscle.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @muscle = Muscle.where("title LIKE?","%#{word}%")
    else
      @muscle = Muscle.all
    end
  end

  
  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
      image
  end

end