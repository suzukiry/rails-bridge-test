class User < ApplicationRecord

  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }

  has_secure_password

  has_many :tests

  has_many :mastered_entries
  has_many :show_mentries, through: :mastered_entries, source: :entry

end
