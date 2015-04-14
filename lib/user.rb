require 'bcrypt'

class User

  include DataMapper::Resource

  attr_accessor :password

  property :id, Serial
  property :username, String, unique: true, message: 'Sorry, that username is already taken.'
  property :name, String
  property :email, String, unique: true, message: 'That email is already registered.'
  property :password_digest, Text

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.authenticate(username, password)
    user = first(username: username)
    user if user && BCrypt::Password.new(user.password_digest) == password
  end

end
