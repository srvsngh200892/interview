class AppClient < ActiveRecord::Base
  enum status: [:Inactive, :Active]
  before_create :generate_key_and_secret

  def generate_key_and_secret
    self.generateAppKey
    self.generateAppSecret
  end

  def generateAppKey
    app_key || self.app_key = generate_app_key
  end

  def generateAppSecret
    app_secret || self.app_secret = generate_app_secret
  end

  def generate_app_key
    loop do
      app_key = Devise.friendly_token
      break app_key unless AppClient.where(app_key: app_key).first
    end
  end

  def generate_app_secret
    loop do
      app_secret = Devise.friendly_token
      break app_secret unless AppClient.where(app_secret: app_secret).first
    end
  end
end
