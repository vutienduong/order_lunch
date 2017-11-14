class User < ActiveRecord::Base
  before_save {email.downcase!}
  validates :username, presence: true, length: {maximum: 30}
  validates :email, presence: true, uniqueness: true, length: {maximum: 255}
  has_secure_password
  validates :password_digest, presence: true, length: {minimum: 1}
end
