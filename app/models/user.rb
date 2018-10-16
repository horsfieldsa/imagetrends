class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :sneakers, dependent: :delete_all
  has_many :favorites, dependent: :delete_all

  validates :username, presence: true
  validates_uniqueness_of :email, :username
  validates_length_of :username, :maximum => 20

  def admin?
    if self.role == "admin" # If you have id == 0 for admin
      true
    else
      false
    end
  end

end