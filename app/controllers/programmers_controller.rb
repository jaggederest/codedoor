class ProgrammersController < ApplicationController
  load_and_authorize_resource

  before_filter :ensure_terms_checked, except: [:index, :show]

  def index
    @programmers = Programmer.all
  end

  def show
    @programmer = Programmer.find(params[:id])
  end

  # There are no new or create routes.  This way, loading the controller will load repos,
  # which can be saved.  The programmer isn't "really created" unless it is activated,
  # which occurs on update.
  def edit
    if current_user.programmer.present?
      @programmer = current_user.programmer
    else
      @programmer = Programmer.new(user_id: current_user.id, visibility: :public)
      @programmer.save({validate: false})
    end
    current_user.github_account.load_repos if current_user.github_account.present?
  end

  def update
    @programmer = Programmer.find(current_user.programmer.id)
    # TODO: Should probably use AJAX here
    if params[:commit] == 'Verify Contribution'
      if params[:repo_owner].blank? || params[:repo_name].blank?
        flash[:alert] = 'Please insert the repository owner and name to verify contributions.'
      elsif params[:repo_owner].include?('/') || params[:repo_name].include?('/')
        flash[:alert] = 'Please include a valid repository owner and name.'
      else
        begin
          repo = current_user.github_account.verify_contribution(params[:repo_owner], params[:repo_name])
        rescue Exception => e
          flash[:alert] = e.message
        end
      end
      flash[:notice] = 'Your contributions to the repository have been added.' if repo.present?
      render :edit
    else
      incomplete = @programmer.incomplete?
      if @programmer.update(update_programmer_params)
        if incomplete
          flash[:notice] = 'Your programmer account has been created.'
        else
          flash[:notice] = 'Your programmer account has been updated.'
        end
        redirect_to programmer_path(@programmer)
      else
        if incomplete
          flash[:alert] = 'Your programmer account could not be created.'
        else
          flash[:alert] = 'Your programmer account could not be updated.'
        end
        render :edit
      end
    end
  end

  private

  # NOTE: user_id is immutable
  def update_programmer_params
    params.require(:programmer).permit(:title, :description, :rate, :availability, :client_can_visit, :onsite_status, :contract_to_hire, :visibility,
      {resume_items_attributes:
        [:company_name, :description, :title, :year_started, :year_finished, :month_started, :month_finished, :is_current, :_destroy, :id],
       education_items_attributes:
        [:school_name, :degree_and_major, :description, :year_started, :year_finished, :month_started, :month_finished, :is_current, :_destroy, :id],
       github_repos_attributes: [:shown, :id]})
  end

  def ensure_terms_checked
    redirect_cannot_be_found unless current_user.present? && current_user.checked_terms?
  end

end
