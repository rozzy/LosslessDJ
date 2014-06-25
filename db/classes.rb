class Users < ActiveRecord::Base
  validates :actual_email, uniqueness: true, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :actual_login, uniqueness: true, presence: true

  before_create do
    self.actual_login = self.actual_login.gsub(/[^\w]/i, '\1').downcase
  end
end

class Secrets < ActiveRecord::Base
  validates :secret_code, uniqueness: true
  before_save :set_expiration_date

  private
  def set_expiration_date
    self.expires = Time.now.utc + 3600
  end
end

class Sessions < ActiveRecord::Base
  validates :secret_code, uniqueness: true
  before_save :set_expiration_date

  private
  def set_expiration_date
    if !self.expired and ((!!self.expires and self.expires > Time.now.utc) or (self.expires == nil))
      self.last_visit = Time.now.utc
      self.expires = Time.now.utc + (3600 * 48)
    else
      self.expired = true
    end
  end
end
