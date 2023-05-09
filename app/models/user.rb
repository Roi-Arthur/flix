class User < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie

  has_secure_password

  validates :name, presence: true
  validates :username, presence: true, format: { with:  /\A[A-Z0-9\-\_]+\z/i},
            uniqueness: { case_sensitivity: false }
  validates :email, presence: true, format: { with: /\S+@\S+/ },
            uniqueness: { case_sensitivity: false }
  validates :password, length: { minimum: 10, allow_blank: true }

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  scope :by_name, -> { order("name") }
  #scope :not_admins, -> { by_name.where("admin = false") }
  scope :not_admins, -> { by_name.where(admin: false) }

end
