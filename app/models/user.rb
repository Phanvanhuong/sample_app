class User < ApplicationRecord
  attr_reader :remember_token
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :email, presence: true,
                    length: {maximum: Settings.max_length_email},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :name,  presence: true, length: {maximum: Settings.max_length_name}
  validates :password, presence: true, length: {minimum: Settings.min_length_pass}, allow_nil: true

  has_secure_password

  private

  def email_downcase
    email.downcase!
  end

  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
                                                  BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    if remember_digest
      false
    else
      BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end
  end

  def forget
    update remember_digest: nil
  end
end
