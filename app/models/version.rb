class Version < ApplicationRecord
  belongs_to :rubygem

  has_many :gem_downloads
  has_many :dependencies

  DOWNLOAD_STATUS = { not_yet: 0, processed: 1, downloaded: 2 }.freeze
  enum download_status: DOWNLOAD_STATUS
end
