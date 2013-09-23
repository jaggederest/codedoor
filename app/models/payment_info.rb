class PaymentInfo < ActiveRecord::Base

  belongs_to :user

  validates :user_id, presence: true, uniqueness: true
  # Note: primary_payment_method is for clients.  There should be another value for payouts.
  validates :primary_payment_method, inclusion: { in: ['paypal', 'balanced'], message: 'must be selected' }

  def balanced_customer

  end

  def associate_card(card_uri)
    p card_uri
  end

  def charge_card

  end
end
