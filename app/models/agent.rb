# frozen_string_literal: true

class Agent < ApplicationRecord
  belongs_to :cluster
  before_create :set_registered_status

  private
  def set_registered_status
    self.status = 'registered'
  end
end
