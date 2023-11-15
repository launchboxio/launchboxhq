# frozen_string_literal: true

class Addon < ApplicationRecord
  has_paper_trail
  acts_as_taggable_on :tags

  has_many :addon_versions

  has_one :default_version, -> { where(default: true) }, class_name: 'AddonVersion'
end
