class ProgrammersController < ApplicationController
  load_and_authorize_resource

  def index
    @programmers = Programmer.all
  end

  def show
    @programmer = Programmer.find(params[:id])
  end

  def new
    if current_user.programmer.present?
      flash[:alert] = 'You are already a programmer.'
      redirect_to root_path
    end
    @programmer = Programmer.new(user_id: current_user.id)
  end

  def create
    @programmer = Programmer.new(programmer_params)
    if @programmer.save
      flash[:notice] = 'Your profile has been created.'
      redirect_to programmer_path(@programmer)
    else
      render :new
    end
  end

  def edit
    @programmer = current_user.programmer
  end

  def update
    @programmer = Programmer.find(current_user.programmer.id)
    if @programmer.update(update_programmer_params)
      flash[:notice] = 'Your profile has been updated.'
      redirect_to programmer_path(@programmer)
    else
      render :edit
    end
  end

  private

  def programmer_params
    unless params[:user_id].blank?
      params[:user_id] = current_user.present? ? current_user.id : nil
    end
    params.require(:programmer).permit(:user_id, :title, :description, :rate, :time_status, :client_can_visit, :onsite_status, :contract_to_hire)
  end

  # NOTE: user_id is immutable
  def update_programmer_params
    params.require(:programmer).permit(:title, :description, :rate, :time_status, :client_can_visit, :onsite_status, :contract_to_hire)
  end

end
