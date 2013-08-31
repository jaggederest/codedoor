class UserAccount < ActiveRecord::Base
  belongs_to :user

  validates :account_id, presence: true
  validates_uniqueness_of :account_id, scope: :type
  validates_uniqueness_of :account_id, scope: :user
  validates :oauth_token, presence: true
  validates :type, presence: true
  validates :user, presence: true
  validates :username, presence: true

end
