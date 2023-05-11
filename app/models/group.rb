class Group < ApplicationRecord
    has_one_attached :image

    has_many :group_users, dependent: :destroy
    has_many :users, through: :group_users, source: :user

    belongs_to :connection, class_name: "GroupUser", foreign_key: "owner_id"
    has_one :owner, through: :connection, source: :user

    def get_group_image(weight, height)
        unless self.image.attached?
            file_path = Rails.root.join('app/assets/images/no_image.jpg')
            image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
        end
        self.image.variant(resize_to_fill: [weight,height]).processed
    end
end
