class ClientsController < ApplicationController
  load_and_authorize_resource

  before_filter :ensure_user_checked_terms, except: [:index, :show]
  before_filter :ensure_no_client, only: [:new, :create]

  def new
    @client = Client.new(user_id: current_user.id)
  end

  def create
    @client = Client.new(client_params)
    @client.user_id = current_user.id

    if @client.save
      flash[:notice] = 'Your client account has been created.'
      render :edit
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
