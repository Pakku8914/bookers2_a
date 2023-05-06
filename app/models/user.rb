class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy


  # class_name: どのテーブルを参照するのか設定
  # foreign_key: 参照する外部キー(カラム)を指定
  # through: 経由するテーブル
  # source: 参照するカラム 

  # フォローされている人
  # Relationshipモデルに対して、followed_idを見てreverse_of_relationshipsという名前でアソシエーション
  # foreign_key(FK)には、@user.xxxとした際に「@user.idがfollower_idかfollowed_idなのか」を指定
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # フォローされている人の情報が欲しい => フォローしている人の情報を取得
  # reverse_of_relationshipsを経由し、follower(belongs_toのやつ)カラムに対してfollowersという名前でアソシエーション
  # そのユーザーがフォローしている人orフォローされている人の一覧を出したい
  has_many :followers, through: :reverse_of_relationships, source: :follower

  # フォローしている人
  # Relationshipモデルに対して、followed_idを見てrelationshipsという名前でアソシエーション
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # フォローしている人の情報が欲しい => フォローされている人の情報を取得
  # relationshipsを経由し、followed(belongs_toのやつ)カラムに対してfollowingsという名前でアソシエーション
  has_many :followings, through: :relationships, source: :followed
  
  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  # userはフォローされる人
  def follow(user)
    relationships.create(followed_id: user.id)
  end

  # userはフォローをはずされるひと
  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end

  # フォローしてるか確認したい人.followings?(フォローされているか確認したい人)
  def following?(user)
    followings.include?(user)
  end

  def get_profile_image(weight, height)
    unless self.profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    self.profile_image.variant(resize_to_fill: [weight,height]).processed
  end

  def create_books_today
    self.books.where(created_at: Time.now.all_day).count.to_i
  end

  def create_books_yesterday
    self.books.where(created_at: Time.now.yesterday.all_day).count.to_i
  end

  def create_books_thisweek
    self.books.where(created_at: (Time.now - 6.day).beginning_of_day..Time.now).count.to_i
  end

  def create_books_lastweek
    self.books.where(created_at: 2.week.ago.beginning_of_day..(Time.now - 7.day).end_of_day).count.to_i
  end

  def number_of_posts_per_week
    # 一週間分のデータ
    @count_week_post = [0, 0, 0, 0, 0, 0, 0]
    @books = self.books
    range = 0..6
    range.each do |num|
      if num == 0
        @count_week_post[0] = @books.where(created_at: Time.now.all_day).count.to_i
      else
        @count_week_post[num] = @books.where(created_at: (num).day.ago.all_day).count.to_i
      end
    end
    return @count_week_post.reverse
  end
end
