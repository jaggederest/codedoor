class ContractorsController < ApplicationController
  # NOTE: A contractor model must belong to a user, and a user model has at most one contractor model.
  load_and_authorize_resource except: :edit

  def index
    @contractors = Contractor.all
  end

  def show
    @contractor = Contractor.find(params[:id])
  end

  def new
    @contractor = Contractor.new(user_id: current_user.id)
  end

  def create
    @contractor = Contractor.new(contractor_params)
    if @contractor.save
      flash[:success] = 'Your profile has been created.'
      redirect_to action: :show
    else
      render :new
    end
  end

  def edit
    @contractor = Contractor.find_by_user_id(current_user.id)
  end

  def update
    if Contractor.update(contractor_params)
      flash[:success] = 'Your profile has been updated.'
      redirect_to action: :show
    else
      flash[:error] = @contractor.errors.full_messages
      redirect_to action: :edit
    end
  end

  private

  def contractor_params
    params.require(:contractor).permit(:user_id, :title, :description, :rate, :time_status, :client_can_visit, :onsite_status, :contract_to_hire)
  end

end
