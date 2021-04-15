class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name,:url, presence: true
  validates :url, format: { with: URI::regexp }

  def gist_url?
    url.start_with?("https://gist")
  end
end
