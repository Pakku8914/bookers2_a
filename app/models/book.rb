class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments
  has_many :favorites
  
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  
  def self.dec_favo_a_week
    includes(:favorites).sort_by{
      |x|
      x.favorites.where(created_at: 1.week.ago..Time.now).count
    }.reverse
  end

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
