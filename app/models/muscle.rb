class Muscle < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :body, length: { maximum: 200 }

  validates :title, presence: true
  validates :body, presence: true

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
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

  
  

  def self.liked_posts(user, page, per_page) # 1. モデル内での操作を開始
    includes(:post_favorites) # 2. post_favorites テーブルを結合
      .where(post_favorites: { user_id: user.id }) # 3. ユーザーがいいねしたレコードを絞り込み
      .order(created_at: :desc) # 4. 投稿を作成日時の降順でソート
      .page(page) # 5. ページネーションのため、指定ページに表示するデータを選択
      .per(per_page) # 6. ページごとのデータ数を指定
  end

  
end