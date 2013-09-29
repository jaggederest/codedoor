class PaymentInfosController < ApplicationController
  load_and_authorize_resource

  before_filter :ensure_user_checked_terms

  def new
    @cards = PaymentInfo.find_or_create_by(user_id: current_user.id).get_cards
  end

  def create
    if params[:error]
      # TODO: If the key refers to one of the fields, the error should be displayed inline.
      flash[:errors] = params[:error].map{ |key, value| "#{key}: #{value}" }
    elsif params[:data] && params[:data][:security_code_check] == 'failed'
      flash[:alert] = 'Your security code is invalid, please try again.'
    elsif params[:data] && params[:data][:uri]
      PaymentInfo.find_or_create_by(user_id: current_user.id).associate_card(params[:data][:uri])

      flash[:notice] = 'Your payment details have been successfully saved.'
    else
      flash[:notice] = 'There was something wrong with processing the payment details.'
    end
    render json: {redirect_to: new_user_payment_info_url(params[:user_id].to_i)}
  end
end
