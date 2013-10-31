class UserAccount < ActiveRecord::Base
  attr_encryptor :oauth_token, key: ENV['OAUTH_ENCRYPTION_PASSWORD']

  belongs_to :user

  validates :account_id, presence: true
  validates_uniqueness_of :account_id, scope: :type
  validates_uniqueness_of :account_id, scope: :user
  validates :encrypted_oauth_token, presence: true
  validates :encrypted_oauth_token_salt, presence: true
  validates :encrypted_oauth_token_iv, presence: true
  validates :type, presence: true
  validates :user, presence: true
  validates :username, presence: true
end
