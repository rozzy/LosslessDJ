class Users < ActiveRecord::Base
  validates :actual_email, uniqueness: true, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :actual_login, uniqueness: true, presence: true

  before_create do
    self.actual_login = self.actual_login.gsub(/[^\w]/i, '\1').downcase
  end
end

class Secrets < ActiveRecord::Base
  validates :secret_code, uniqueness: true
  validates :users_id, uniqueness: true
  before_create :set_expiration_date

  private
  def set_expiration_date
    self.expires = Time.now + 3600
  end
end
