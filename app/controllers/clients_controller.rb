class ClientsController < ApplicationController
  before_filter :ensure_user_checked_terms, only: [:new, :create]
  before_filter :client_required, only: [:edit, :update]
  before_filter :ensure_no_client, only: [:new, :create]
  load_and_authorize_resource

  def new
    @client = Client.new(user_id: current_user.id)
  end

  def create
    @client = Client.new(client_params)
    @client.user_id = current_user.id

    if @client.save
      flash[:notice] = 'Your client account has been created.'
      redirect_to client_signed_up_path
    else
      flash[:alert] = 'Your client account could not be created.'
      render :new
    end
  end

  def edit
    @client = current_user.client
  end

  def update
    @client = Client.find(current_user.client.id)
    if @client.update(client_params)
      flash[:notice] = 'Your client account has been updated.'
    else
      flash[:alert] = 'Your client account could not be updated.'
    end
    render :edit
  end

  private

  def client_params
    params.require(:client).permit(:company, :description)
  end

  def ensure_no_client
    redirect_to action: :edit if current_user.client.present?
  end

end
