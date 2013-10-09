class User < ActiveRecord::Base
  # For now, GitHub is the only way to log in (but it does require :database_authenticatable)
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: [:github]

  has_many :user_accounts
  has_many :github_user_accounts
  has_many :github_repos
  has_many :skills
  has_one  :programmer
  has_one  :client
  has_one  :payment_info

  validates :full_name, presence: true
  validates :country, presence: true, if: :checked_terms?
  validates :city, presence: true, if: :checked_terms?
  validates :state, presence: { if: Proc.new{|user| user.checked_terms? && user.american?} }
  validates :email, uniqueness: true, format: { with: /\A.*@.*\..*\z/ }
  validates :checked_terms, inclusion: { in: [true], on: :update, message: '^The Terms of Use must be accepted.' }

  def self.find_for_github_oauth(auth, signed_in_resource=nil)
    user_account = GithubUserAccount.where(account_id: auth.uid).first

    if user_account
      user = user_account.user
    else
      User.transaction do
        user = User.new
        user.full_name = auth.extra.raw_info.name
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.save(validate: false)

        user_account = GithubUserAccount.new
        user_account.user = user
        user_account.account_id = auth.uid
        user_account.username = auth.info.nickname
        user_account.oauth_token = auth.credentials.token
        user_account.save!
      end
    end
    user
  end

  def american?
    country == 'US'
  end

  # Since uniqueness is scoped to account_id and user, there can only be one
  def github_account
    self.github_user_accounts.first
  end

  def location_text
    if american?
      "#{city}, #{States::HASH.invert[state.to_sym]} (US)"
    else
      "#{city}, #{Countries::supported_by_paypal.invert[country.to_sym]}"
    end
  end

end
