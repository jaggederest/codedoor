require 'spec_helper'

describe ScrapeHtml do
  it 'should return true if the user is a contributor' do
    FakeWebHelpers.mock_scrape_rails_contributor('dhh')
    ScrapeHtml.is_contributor_through_html?('dhh', 'rails', 'rails').should be_true
  end

  it 'should return false if the user is not a contributor' do
    FakeWebHelpers.mock_scrape_rails_noncontributor('random-user-that-did-not-contribute')
    ScrapeHtml.is_contributor_through_html?('random-user-that-did-not-contribute', 'rails', 'rails').should be_false
  end
end
