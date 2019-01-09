class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :images, dependent: :delete_all
  has_many :favorites, dependent: :delete_all
  has_many :comments, dependent: :delete_all

  validates :username, presence: true
  validates_uniqueness_of :email, :username
  validates_length_of :username, :maximum => 20

  after_create_commit :log_create, :record_event
  after_update_commit :log_update
  after_destroy_commit :log_destroy

  def admin?
    if self.role == "admin" # If you have id == 0 for admin
      #user_logger.info("User has admin role: #{self.username}")
      true
    else
      #user_logger.warn("User does not have admin role: #{self.username}")
      false
    end
  end

  private

  # Record Event For Perosnalize
  def record_event
    event = {
      type: 'user',
      USER_ID: self.id
    }

    EventRecordJob.perform_async(event)
  end

  def log_create
    user_logger.info("User created: #{self.username}")
  end

  def log_update
    user_logger.info("User updated: #{self.username}")
  end

  def log_destroy
    user_logger.info("User deleted: #{self.username}")
  end

  def user_logger
    @@user_logger ||= Logger.new("#{Rails.root}/log/application.log")
  end

end