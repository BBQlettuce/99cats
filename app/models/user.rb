class User < ActiveRecord::Base
  def reset_session_token!
    token = SecureRandom::urlsafe_base64
    until User.find_by(session_token: token).nil?
      token = SecureRandom::urlsafe_base64
    end
    self.session_token = token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end
end