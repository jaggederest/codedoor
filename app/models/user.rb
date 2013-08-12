class User < ActiveRecord::Base
  # For now, GitHub is the only way to log in (but it does require :database_authenticatable)
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: [:github]

  has_many :user_accounts
  has_one  :programmer

  validates :full_name, presence: true
  validates :email, uniqueness: true
  validates :checked_terms, inclusion: { in: [true], on: :update, message: '^The Terms of Use must be accepted.' }

  def self.find_for_github_oauth(auth, signed_in_resource=nil)
    user_account = UserAccount.where(provider: auth.provider, account_id: auth.uid).first
    if user_account
      user = user_account.user
    else
      User.transaction do
        user = User.new
        user.full_name = auth.extra.raw_info.name
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.save!

        user_account = UserAccount.new
        user_account.user = user
        user_account.account_id = auth.uid
        user_account.provider = auth.provider
        user_account.oauth_token = auth.credentials.token
        user_account.save!
      end
    end
    user
  end
end
