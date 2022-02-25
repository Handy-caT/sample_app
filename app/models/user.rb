class User < ApplicationRecord
  attr_accessor :remember_token, :old_password

  before_save {self.email = email.downcase}
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, length: { maximum: 255 },
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}

  has_secure_password validations: false
  VALID_PASSWORD_REGEX = /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!$%^&*-]).{8,24}/


  validate :password_presence, on: :new
  validate :correct_old_password, on: :update
  validates :password, length: { minimum: 8, maximum: 24}, allow_blank: true, confirmation: true
  validate :password_complexity

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string,:cost => cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest,User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest,nil)
  end

  private

  def password_complexity
    return if password.blank? || password =~ VALID_PASSWORD_REGEX
    errors.add :password, "Password must be 8-24 characters and include: uppercase,lowercase,special character
                            and number!"
  end

  def password_presence
    if password.blank?
      errors.add :password, :blank
    end
  end

  def correct_old_password
    unless password.blank?
      return if BCrypt::Password.new(password_digest_was).is_password?(old_password)
      errors.add :old_password, "is incorrect"
    end
  end


end
