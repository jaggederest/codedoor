require 'balanced'

Balanced.configure(ENV['BALANCED_SECRET'])

class PaymentInfo < ActiveRecord::Base

  belongs_to :user

  validates :user_id, presence: true, uniqueness: true

  def associate_card(card_uri)
    balanced_customer.add_card(card_uri)
  end

  # TODO: Use this method! :)
  def charge_card(total)
    raise 'Tried to charge card of user without a balanced account' unless has_balanced_account?
    # Please remember, the total has to be in cents!
    balanced_customer.debit(amount: total)
  end

  def get_cards
    has_balanced_account? ? balanced_customer.cards : []
  end

  protected

  def has_balanced_account?
    balanced_customer_uri.present?
  end

  def balanced_customer
    create_balanced_customer unless has_balanced_account?
    Balanced::Customer.find(balanced_customer_uri)
  end

  def create_balanced_customer
    user = User.find(self.user_id)
    customer = Balanced::Customer.new(name: user.full_name,
                                      email: user.email).save
    self.balanced_customer_uri = customer.attributes[:uri]
    self.save!
  end

end
