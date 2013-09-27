class PaymentInfosController < ApplicationController
  load_and_authorize_resource

  before_filter :ensure_user_checked_terms

  def new
    @cards = PaymentInfo.find_or_create_by(user_id: current_user.id).get_cards
  end

  def create
    if params[:error]
      error_array = []
      params[:error].each_value { |value| error_array << value.to_s unless value.blank? }

      flash[:error] = error_array

      render json: {redirect_to: new_user_payment_info_url(params["user_id"].to_i)}
    elsif params[:data][:security_code_check] == "failed"
      flash[:error] = ["Your security code is invalid, please try again."]

      render json: {redirect_to: new_user_payment_info_url(params["user_id"].to_i)}
    else
      card_uri = params[:data][:uri]
      PaymentInfo.find_or_create_by(user_id: current_user.id).associate_card(card_uri)

      flash[:notice] = "Your payment details have been successfully saved."

      render json: {redirect_to: new_user_payment_info_url(params["user_id"].to_i)}
    end
  end
end
