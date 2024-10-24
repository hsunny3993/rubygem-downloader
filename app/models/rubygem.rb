class Rubygem < ApplicationRecord
  has_many :versions
  has_many :gem_downloads
  has_many :dependencies

  has_many :linkset
end
