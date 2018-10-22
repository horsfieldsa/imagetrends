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

  after_create_commit :log_creation

  def admin?
    if self.role == "admin" # If you have id == 0 for admin
      user_logger.info("User has admin role: #{self.username}")
      true
    else
      user_logger.warn("User does not have admin role: #{self.username}")
      false
    end
  end

  private

  def log_creation
    user_logger.info("User created: #{self.username}")
  end

  def user_logger
    @@user_logger ||= Logger.new("#{Rails.root}/log/application.log")
  end

end