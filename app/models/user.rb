class User < ActiveRecord::Base
  attr_reader :password

  validates :user_name, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  after_initialize :ensure_session_token

  has_many :cats,
    class_name: "Cat",
    foreign_key: :user_id,
    primary_key: :id

  has_many :requests,
    class_name: "CatRentalRequest",
    foreign_key: :requester_id,
    primary_key: :id
    
  def self.generate_session_token
    token = SecureRandom::urlsafe_base64
    until User.find_by(session_token: token).nil?
     token = SecureRandom::urlsafe_base64
   end
   token
  end

  def reset_session_token!
    token = self.class.generate_session_token
    self.update!(session_token: token)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(username, password)
    user = User.find_by(user_name: username)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  private
  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end
end
