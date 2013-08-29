class UserAccount < ActiveRecord::Base
  belongs_to :user

  validates :account_id, presence: true, uniqueness: {scope: :user}
  validates :oauth_token, presence: true
  validates :type, presence: true
  validates :user, presence: true
  validates :username, presence: true

end
