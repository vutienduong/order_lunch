class User < ActiveRecord::Base
  before_save {email.downcase!}
  validates :username, presence: true, length: {maximum: 50}
  validates :email, presence: true, uniqueness: true, length: {maximum: 255}
  has_secure_password
  validates :password, presence: true, length: {minimum: 1}
end
