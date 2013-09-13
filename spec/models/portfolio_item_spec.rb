require 'spec_helper'

describe PortfolioItem do
  context 'validations' do
    before :each do
      @portfolio_item = FactoryGirl.create(:portfolio_item)
    end

    it { should ensure_length_of(:title).is_at_least(5).is_at_most(80) }
    it { should ensure_length_of(:url).is_at_most(160) }

    it 'should allow a valid url' do
      @portfolio_item.url = 'https://www.codedoor.com'
      @portfolio_item.valid?.should be_true
    end

    it 'should allow a valid url without a protocol' do
      @portfolio_item.url = 'codedoor.com'
      @portfolio_item.valid?.should be_true
    end

    it 'should not allow an invalid url' do
      @portfolio_item.url = 'codedoor#.#com'
      @portfolio_item.valid?.should be_false
    end
  end

  context 'associations' do
    it { should belong_to(:programmer) }
  end

  context 'abilities' do
    it 'should have the permissions of a programmer resume item' do
      validate_ability_of_programmer_resume_item(:portfolio_item)
    end
  end

end
