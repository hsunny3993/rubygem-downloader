class GemDownload < ApplicationRecord
  belongs_to :rubygem
  belongs_to :version
end
