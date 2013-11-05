require 'spec_helper'

describe ProgrammersController do

  def valid_programmer(user_id)
    {user_id: user_id,
     title: 'title',
     description: 'description',
     rate: 50,
     availability: 'full-time',
     onsite_status: 'occasional',
     visibility: 'public',
     skill_ids: [Skill.find_by_name('Android').id],
     contract_to_hire: true}
  end

  before :each do
    @user = FactoryGirl.create(:user_checked_terms)
    sign_in(@user)
  end

  describe 'GET index' do
    describe 'visibility to search' do
      before :each do
        @public_programmer = FactoryGirl.create(:programmer, visibility: 'public', state: 'activated', qualified: true)
        @codedoor_programmer = FactoryGirl.create(:programmer, visibility: 'codedoor', state: 'activated', qualified: true)
        @private_programmer = FactoryGirl.create(:programmer, visibility: 'private', state: 'activated', qualified: true)
        @unactivated_programmer = FactoryGirl.create(:programmer, visibility: 'public', state: 'incomplete', qualified: true)
        @unqualified_programmer = FactoryGirl.create(:programmer, visibility: 'public', state: 'activated', qualified: false)
      end

      it 'assigns @programmers and renders template' do
        get :index, skill_name: ''
        assigns(:programmers).should eq([@public_programmer, @codedoor_programmer])
        response.should render_template('index')
      end

      it 'still renders the index template logged out, but without the programmers of "codedoor" visibility' do
        sign_out(@user)
        get :index, skill_name: ''
        assigns(:programmers).should eq([@public_programmer])
        response.should render_template('index')
      end
    end

    describe 'searching by skill' do
      before :each do
        actionscript = Skill.find_by_name('ActionScript')
        javascript = Skill.find_by_name('JavaScript')
        @as_programmer = FactoryGirl.create(:programmer, :qualified, visibility: 'public', skills: [actionscript])
        @js_programmer = FactoryGirl.create(:programmer, :qualified, visibility: 'public', skills: [javascript])
        @both_programmer = FactoryGirl.create(:programmer, :qualified, visibility: 'public', skills: [actionscript, javascript])
        @neither_programmer = FactoryGirl.create(:programmer, :qualified, visibility: 'public')
        @unqualified_programmer = FactoryGirl.create(:programmer, qualified: false)
      end

      it 'shows all the programmers if there is no skill_name' do
        get :index, skill_name: ''
        assigns(:programmers).should eq([@as_programmer, @js_programmer, @both_programmer, @neither_programmer])
      end

      it 'searches for just JavaScript programmers if that is the query' do
        get :index, skill_name: 'JavaScript'
        assigns(:programmers).should eq([@js_programmer, @both_programmer])
      end

      it 'shows all the programmers if the skill name is invalid' do
        get :index, skill_name: 'not_a_real_skill'
        assigns(:programmers).should eq([@as_programmer, @js_programmer, @both_programmer, @neither_programmer])
      end
    end
  end

  describe 'GET show' do
    before :each do
      @programmer = FactoryGirl.create(:programmer, :qualified, visibility: 'codedoor')
    end

    it 'assigns @programmer and renders template' do
      get :show, id: @programmer.id
      assigns(:programmer).should eq(@programmer)
      response.should render_template('show')
    end

    it 'still renders the show template logged out if the programmer is public' do
      sign_out(@user)
      @programmer.visibility = 'public'
      @programmer.save!
      get :show, id: @programmer.id
      response.should render_template('show')
    end

    it 'redirects to programmer settings if you try to visit own profile, and it is incomplete' do
      @programmer = FactoryGirl.create(:programmer, user: @user, state: 'incomplete')
      get :show, id: @programmer.id
      response.should redirect_to(edit_user_programmer_path(@user))
    end

    it 'does not render the show template logged out if the programmer is not public' do
      sign_out(@user)
      get :show, id: @programmer.id
      response.should redirect_to(root_path)
      flash[:alert].should eq('Information cannot be found.')
    end

    it 'does not render the show template logged out if the programmer is not activated' do
      @programmer = FactoryGirl.create(:programmer, state: 'incomplete')
      get :show, id: @programmer.id
      response.should redirect_to(root_path)
      flash[:alert].should eq('Information cannot be found.')
    end

    it 'does not render the show template logged out if the programmer is not qualified' do
      @programmer = FactoryGirl.create(:programmer, state: 'activated', qualified: false)
      get :show, id: @programmer.id
      response.should redirect_to(root_path)
      flash[:alert].should eq('Information cannot be found.')
    end

    it 'fails gracefully when the programmer id does not exist' do
      get :show, id: 9999999
      response.should redirect_to(root_path)
      flash[:alert].should eq('Information cannot be found.')
    end

    # TODO: When you can disable a profile, they should not be available to anyone other than the programmer
  end

  describe 'GET edit' do

    it 'should load github repos, assign @programmer and render view when programmer id is correct' do
      programmer = FactoryGirl.create(:programmer, user: @user)
      FactoryGirl.create(:github_user_account, user: @user)
      GithubUserAccount.any_instance.should_receive(:load_repos).exactly(:once).and_return([])
      get :edit, user_id: @user.id, id: programmer.id
      assigns(:programmer).should eq(programmer)
      response.should render_template('edit')
    end

    it 'should not be allowed when terms are not checked' do
      programmer = FactoryGirl.create(:programmer, user: @user)
      @user.checked_terms = false
      @user.save(validate: false)
      get :edit, user_id: @user.id, id: programmer.id
      response.should redirect_to(edit_user_path(@user))
    end

    it 'should not be allowed when logged out' do
      sign_out(@user)
      programmer = FactoryGirl.create(:programmer)
      get :edit, user_id: @user.id, id: programmer.id
      response.should redirect_to(user_omniauth_authorize_path(:github))
    end

    it 'should not be allowed when the programmer id is different from that of the user' do
      programmer = FactoryGirl.create(:programmer, user: @user)
      other_programmer = FactoryGirl.create(:programmer)
      get :edit, user_id: @user.id, id: other_programmer.id
      response.should redirect_to(root_path)
      flash[:alert].should eq('Information cannot be found.')
    end

  end

  describe 'POST update' do
    before :each do
      @programmer = FactoryGirl.create(:programmer, user: @user, rate: 20, state: :activated)
    end

    it 'should ignore the user_id parameter, redirect to show and update the programmer' do
      programmer_params = valid_programmer('user-id-ignored')
      programmer_params[:rate] = 500
      post :update, user_id: @user.id, id: @programmer.id, programmer: programmer_params
      programmer = Programmer.find_by_user_id(@user.id)
      response.should redirect_to(programmer_path(programmer))
      flash[:notice].should eq('Your programmer account has been updated.')
      programmer.user_id.should eq(@user.id)
      programmer.rate.should eq(500)
    end

    it 'should update skills' do
      @programmer.reload.skills.should eq([Skill.find_by_name('Android')])
      programmer_params = valid_programmer('user-id-ignored')
      programmer_params[:skill_ids] = [Skill.find_by_name('C++').id]
      post :update, user_id: @user.id, id: @programmer.id, programmer: programmer_params
      @programmer.reload.skills.should eq([Skill.find_by_name('C++')])
    end

    it 'should update resume' do
      programmer_params = valid_programmer('user-id-ignored')
      @programmer.resume_items.count.should be(0)
      programmer_params[:resume_items_attributes] =
       {'0' =>
         {company_name: 'test company',
          title: 'test title',
          description: 'description',
          month_started: 6,
          year_started: 2010,
          month_finished: 1,
          year_finished: 2011,
          _destroy: 'false'}
       }
      post :update, user_id: @user.id, id: @programmer.id, programmer: programmer_params
      @programmer.reload.resume_items.count.should be(1)
    end

    it 'should update education' do
      programmer_params = valid_programmer('user-id-ignored')
      @programmer.resume_items.count.should be(0)
      programmer_params[:education_items_attributes] =
       {'0' =>
         {school_name: 'test school',
          month_started: 6,
          year_started: 2010,
          month_finished: 1,
          year_finished: 2011,
          _destroy: 'false'}
       }
      post :update, user_id: @user.id, id: @programmer.id, programmer: programmer_params
      @programmer.reload.education_items.count.should be(1)
    end

    it 'should update projects' do
      programmer_params = valid_programmer('user-id-ignored')
      @programmer.resume_items.count.should be(0)
      programmer_params[:portfolio_items_attributes] =
       {'0' =>
         {title: 'test title',
          url: 'www.example.com',
          _destroy: 'false'}
       }
      post :update, user_id: @user.id, id: @programmer.id, programmer: programmer_params
      @programmer.reload.portfolio_items.count.should be(1)
    end

    it 'should update visibility of github repos' do
      programmer_params = valid_programmer('user-id-ignored')
      repo = FactoryGirl.create(:github_repo, programmer: @programmer, shown: false)
      programmer_params[:github_repos_attributes] = {'0' => {'shown' => '1', 'id' => repo.id}}
      post :update, user_id: @user.id, id: @programmer.id, programmer: programmer_params
      repo.reload.shown.should be_true
    end

    it 'should say that the programmer was created if the programmer was not activated' do
      @programmer.update_columns(state: 'incomplete')
      programmer_params = valid_programmer('user-id-ignored')
      programmer_params[:rate] = 500
      post :update, user_id: @user.id, id: @programmer.id, programmer: programmer_params
      flash[:notice].should eq('Your programmer account has been created.')
    end

    it 'should not be allowed when terms are not checked' do
      @user.checked_terms = false
      @user.save(validate: false)
      programmer_params = valid_programmer('user-id-ignored')
      post :update, user_id: @user.id, id: @programmer.id, programmer: programmer_params
      response.should redirect_to(edit_user_path(@user))
    end

    it 'should not be allowed when logged out' do
      sign_out(@user)
      post :update, user_id: @user.id, id: @programmer.id, programmer: valid_programmer(@user.id)
      response.should redirect_to(user_omniauth_authorize_path(:github))
    end

    it 'should not be allowed if id refers to a programmer not associated with the user' do
      other_programmer = FactoryGirl.create(:programmer)
      post :update, user_id: @user.id, id: other_programmer.id, programmer: valid_programmer(other_programmer.user_id)
      response.should redirect_to(root_path)
      flash[:alert].should eq('Information cannot be found.')
      Programmer.find_by_user_id(@user.id).should eq(@programmer)
    end

    it 'should fail creation if the parameters passed in are invalid' do
      @programmer.update_columns(state: 'incomplete')
      invalid_programmer = valid_programmer(@user.id)
      invalid_programmer[:rate] = 1000000
      post :update, user_id: @user.id, id: @programmer.id, programmer: invalid_programmer
      response.should render_template('edit')
      flash[:alert].should eq('Your programmer account could not be created.')
      assigns(:programmer).errors[:rate].should eq(['must be less than or equal to 1000'])
      # The rate in @programmer should be 1000000, because the user will see the input they typed in.
      assigns(:programmer).rate.should eq(1000000)
      @programmer.reload.rate.should eq(20)
    end

    it 'should fail update if the parameters passed in are invalid' do
      invalid_programmer = valid_programmer(@user.id)
      invalid_programmer[:rate] = 1000000
      post :update, user_id: @user.id, id: @programmer.id, programmer: invalid_programmer
      response.should render_template('edit')
      flash[:alert].should eq('Your programmer account could not be updated.')
      assigns(:programmer).errors[:rate].should eq(['must be less than or equal to 1000'])
      # The rate in @programmer should be 1000000, because the user will see the input they typed in.
      assigns(:programmer).rate.should eq(1000000)
      @programmer.reload.rate.should eq(20)
    end

  end

  describe 'POST verify_contribution' do
    before :each do
      @programmer = FactoryGirl.create(:programmer, user: @user, rate: 20, state: :activated)
      @user_account = FactoryGirl.create(:github_user_account, user: @user)
    end

    it 'should create a github_repo if the user has made a contribution' do
      @user_account.username = 'dhh'
      @user_account.save!
      
      FakeWebHelpers.mock_api_large_repo(@user_account.oauth_token)
      FakeWebHelpers.mock_scrape_rails_contributor('dhh')
      FakeWebHelpers.mock_rails_repo_request
      
      post :verify_contribution, user_id: @user.id, id: @programmer.id, repo_owner: 'rails', repo_name: 'rails', format: :json
      response.response_code.should eq(200)
      JSON.parse(response.body)['success'].should eq('Your contributions to rails/rails have been added.')
    end

    it 'should return error if the repository has already been added' do
      FactoryGirl.create(:github_repo, programmer: @programmer, repo_owner: 'repo', repo_name: 'already-exists')
      post :verify_contribution, user_id: @user.id, id: @programmer.id, repo_owner: 'repo', repo_name: 'already-exists', format: :json
      response.response_code.should eq(400)
      JSON.parse(response.body)['error'].should eq('This repository has already been added.')
    end

    it 'should return error if the user has not made a contribution' do
      FakeWebHelpers.mock_scrape_rails_noncontributor(@user_account.username)
      FakeWebHelpers.mock_api_large_repo(@user_account.oauth_token)
      post :verify_contribution, user_id: @user.id, id: @programmer.id, repo_owner: 'rails', repo_name: 'rails', format: :json
      response.response_code.should eq(400)
      JSON.parse(response.body)['error'].should eq('You have not contributed any code to this repository.')
    end

    it 'should return error if repo does not exist' do
      FakeWebHelpers.mock_missing_repo(@user_account.oauth_token)
      post :verify_contribution, user_id: @user.id, id: @programmer.id, repo_owner: 'rhc2104', repo_name: 'repo-that-does-not-exist', format: :json
      response.response_code.should eq(400)
      JSON.parse(response.body)['error'].should eq('The repository does not exist.')

    end

    it 'should return specific error if repo values are blank' do
      post :verify_contribution, user_id: @user.id, id: @programmer.id, repo_owner: '', repo_name: '', format: :json
      response.response_code.should eq(400)
      JSON.parse(response.body)['error'].should eq('Please include a valid repository owner and name.')
    end

    it 'should return specific error if repo values have "/" in them' do
      post :verify_contribution, user_id: @user.id, id: @programmer.id, repo_owner: 'invalid/owner', repo_name: 'invalid/name', format: :json
      response.response_code.should eq(400)
      JSON.parse(response.body)['error'].should eq('Please include a valid repository owner and name.')
    end
  end

end
