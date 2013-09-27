require 'balanced'

Balanced.configure(ENV["BALANCED_SECRET"])

class PaymentInfo < ActiveRecord::Base

  belongs_to :user

  validates :user_id, presence: true, uniqueness: true

  def balanced_customer
    if self.balanced_customer_uri.nil?
      user = User.find(self.user_id)
      customer = Balanced::Customer.new(name: user.full_name,
                                        email: user.email).save
      self.balanced_customer_uri = customer.attributes["uri"]
      self.save
    end
    Balanced::Customer.find(self.balanced_customer_uri)
  end

  def associate_card(card_uri)
    balanced_customer.add_card(card_uri)
  end

  def charge_card(total)
    # please remember the total has to be in cents!
    customer = self.balanced_customer
    customer.debit(amount: total)
  end

  def get_cards
    balanced_customer.cards
  end
end
