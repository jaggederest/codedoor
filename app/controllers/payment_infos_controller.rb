class PaymentInfosController < ApplicationController
  load_and_authorize_resource

  before_filter :ensure_user_checked_terms
  before_filter :ensure_no_payment, only: [:new, :create]

  def new
    @payment_info = PaymentInfo.new(user_id: current_user.id)
  end

  def create
    @payment_info = PaymentInfo.new(payment_info_params)
    @payment_info.user_id = current_user.id

    if @payment_info.save
      flash[:notice] = 'Your payment information has been created.'
      render :edit
    else
      flash[:alert] = 'Your payment information could not be created.'
      render :new
    end
  end

  def edit
    @payment_info = current_user.payment_info
  end

  def update
    @payment_info = PaymentInfo.find(current_user.payment_info.id)
    if @payment_info.update(payment_info_params)
      flash[:notice] = 'Your payment information has been updated.'
    else
      flash[:alert] = 'Your payment information could not be updated.'
    end
    render :edit
  end

  private

  def payment_info_params
    params.require(:payment_info).permit(:primary_payment_method)
  end

  def ensure_no_payment
    redirect_to action: :edit if current_user.payment_info.present?
  end

end
