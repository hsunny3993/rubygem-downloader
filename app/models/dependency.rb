class Dependency < ApplicationRecord
  belongs_to :rubygem
  belongs_to :version
end
