class ProgrammersController < ApplicationController
  load_and_authorize_resource

  before_filter :ensure_terms_checked, except: [:index, :show]

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
    @programmer = Programmer.new(user_id: current_user.id, visibility: :public)
  end

  def create
    @programmer = Programmer.new(programmer_params)
    if @programmer.save
      flash[:notice] = 'Your programmer account has been created.'
      redirect_to programmer_path(@programmer)
    else
      flash[:alert] = 'Your programmer account could not be created.'
      render :new
    end
  end

  def edit
    @programmer = current_user.programmer
  end

  def update
    @programmer = Programmer.find(current_user.programmer.id)
    if @programmer.update(update_programmer_params)
      flash[:notice] = 'Your programmer account has been updated.'
      redirect_to programmer_path(@programmer)
    else
      flash[:alert] = 'Your programmer account could not be updated.'
      render :edit
    end
  end

  private

  def programmer_params
    params[:user_id] = current_user.id if params[:user_id].present? && current_user.present?
    params.require(:programmer).permit(:user_id, :title, :description, :rate, :time_status, :client_can_visit, :onsite_status, :contract_to_hire, :visibility, resume_items_attributes: [:company_name, :description, :year_started, :year_finished, :_destroy, :id])
  end

  # NOTE: user_id is immutable
  def update_programmer_params
    params.require(:programmer).permit(:title, :description, :rate, :time_status, :client_can_visit, :onsite_status, :contract_to_hire, :visibility, resume_items_attributes: [:company_name, :description, :year_started, :year_finished, :_destroy, :id])
  end

  def ensure_terms_checked
    redirect_cannot_be_found unless current_user.present? && current_user.checked_terms?
  end

end
