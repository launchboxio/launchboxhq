# frozen_string_literal: true

class Addon < ApplicationRecord
  has_paper_trail
  acts_as_taggable_on :tags
end
