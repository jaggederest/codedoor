require 'spec_helper'

describe ScrapeHtml do
  it 'should return true if the user is a contributor' do
    ScrapeHtml.is_contributor_through_html?('dhh', 'rails', 'rails').should be_true
  end

  it 'should return false if the user is not a contributor' do
    ScrapeHtml.is_contributor_through_html?('random-user-that-did-not-contribute', 'rails', 'rails').should be_false
  end
end
