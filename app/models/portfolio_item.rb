class PortfolioItem < ActiveRecord::Base

  belongs_to :programmer

  validates :title, length: { minimum: 5, maximum: 80 }
  validates :url, length: { maximum: 160 }
  validate :url_is_valid

  before_save :normalize_url

  private

  def url_is_valid
    begin
      URI.parse(self.url)
    rescue URI::InvalidURIError
      errors.add(:url, :invalid)
    end
  end

  def normalize_url
    begin
      parsed_url = URI.parse(self.url)
      self.url = 'http://' + self.url unless parsed_url.scheme.present?
    rescue URI::InvalidURIError
    end
  end

end
