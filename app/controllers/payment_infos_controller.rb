class PaymentInfosController < ApplicationController
  load_and_authorize_resource

  before_filter :ensure_user_checked_terms
  before_filter :ensure_no_payment, only: [:new, :create]

  def create
    p params
  end

  def edit

  end

  def update

  end

  private

  def payment_info_params
    params.require(:payment_info).permit(:primary_payment_method)
  end

  def ensure_no_payment
    redirect_to action: :edit if current_user.payment_info.present?
  end

end
