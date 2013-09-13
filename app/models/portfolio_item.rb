class PortfolioItem < ActiveRecord::Base

  belongs_to :programmer

  validates :title, length: { minimum: 5, maximum: 80 }
  validates :url, length: { maximum: 160 }
  validate :url_is_valid

  private

  def url_is_valid
    begin
      URI.parse(self.url)
    rescue URI::InvalidURIError
      errors.add(:url, :invalid)
    end
  end

end
