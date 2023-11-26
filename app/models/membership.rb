# frozen_string_literal: true

class Membership < ApplicationRecord
  belongs_to :organization
  belongs_to :user
end
