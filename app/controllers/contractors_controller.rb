class ContractorsController < ApplicationController
  # NOTE: A contractor model must belong to a user, and a user model has at most one contractor model.
  load_and_authorize_resource

  def index
    @contractors = Contractor.all
  end

  def show
    @contractor = Contractor.find(params[:id])
  end

  def new
    if current_user.contractor.present?
      flash[:alert] = 'You are already a contractor.'
      redirect_to root_path
    end
    @contractor = Contractor.new(user_id: current_user.id)
  end

  def create
    @contractor = Contractor.new(contractor_params)
    if @contractor.save
      flash[:notice] = 'Your profile has been created.'
      redirect_to contractor_path(@contractor)
    else
      render :new
    end
  end

  def edit
    @contractor = current_user.contractor
  end

  def update
    @contractor = Contractor.find(params[:id])
    if @contractor.update(update_contractor_params)
      flash[:notice] = 'Your profile has been updated.'
      redirect_to contractor_path(params[:id])
    else
      render :edit
    end
  end

  private

  def contractor_params
    params.require(:contractor).permit(:user_id, :title, :description, :rate, :time_status, :client_can_visit, :onsite_status, :contract_to_hire)
  end

  # NOTE: user_id is immutable
  def update_contractor_params
    params.require(:contractor).permit(:title, :description, :rate, :time_status, :client_can_visit, :onsite_status, :contract_to_hire)
  end

end
