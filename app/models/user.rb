require 'openssl'

# Модель пользователя.
#
# Каждый экземпляр этого класса — загруженная из БД инфа о конкретном юзере.
class User < ActiveRecord::Base
  # Параметры работы для модуля шифрования паролей
  ITERATIONS = 20_000
  DIGEST = OpenSSL::Digest::SHA256.new

  attr_accessor :password

  has_many :questions


  validates :email, :username, presence: true
  validates :email, :username, uniqueness: true
  validates_format_of :email, :with => /.+@.+\..+/i
  validates :username, length: {maximum: 40, message: "слшком много символов. Введите не более 40 символов"}
  validates_format_of :username, :with => /\w/

  validates :password, presence: true, on: :create

  validates_confirmation_of :password

  before_validation :username_downcase

  before_save :encrypt_password



  def username_downcase
    username.downcase! if username.present?
    email.downcase! if email.present?
  end


  def encrypt_password
    if password.present?
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      self.password_hash = User.hash_to_string(
          OpenSSL::PKCS5.pbkdf2_hmac(
              password, password_salt, ITERATIONS, DIGEST.length, DIGEST
          )
      )

    end
  end

  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  def self.authenticate(email, password)
    user = find_by(email: email)

    return nil unless user.present?

    hashed_password = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(
            password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST
        )
    )

    return user if user.password_hash == hashed_password

    nil
  end
end
