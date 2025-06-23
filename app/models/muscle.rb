class Muscle < ApplicationRecord
  has_many_attached :images
  has_many_attached :videos
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  validate :validate_images

  def validate_images
    return unless images.attached?

    images.each do |image|
      if image.byte_size > 5.megabytes
        errors.add(:images, "は5MB以下にしてください")
      end

      acceptable_types = ["image/jpeg", "image/png", "image/webp"]
      unless acceptable_types.include?(image.content_type)
        errors.add(:images, "はJPEG, PNG, WebP形式のみ対応しています")
      end

      begin
        # 画像ファイルが破損していないかチェック
        ImageProcessing::Vips.source(image).resize_to_limit(800, 800).call
      rescue => e
        errors.add(:images, "の読み込みに失敗しました（形式が不正か壊れています）")
      end
    end
  end



  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  
  def self.search_for(content, method)
    if method == 'perfect'
      Muscle.where(title: content)  # name -> title に修正
    elsif method == 'forward'
      Muscle.where('title LIKE ?', content + '%')  # name -> title に修正
    elsif method == 'backward'
      Muscle.where('title LIKE ?', '%' + content)  # name -> title に修正
    else
      Muscle.where('title LIKE ?', '%' + content + '%')  # name -> title に修正
    end
  end
  
  
  def get_images
    if images.attached?
      images
    else
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      images.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
      images
    end

  def self.liked_posts(user, page, per_page)
    joins(:favorites)
      .where(favorites: { user_id: user.id })
      .order(created_at: :desc)
      .page(page)
      .per(per_page)
    end
  end
end