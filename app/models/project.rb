# frozen_string_literal: true

class Project < ApplicationRecord
  enum status: {
    failed: 'failed',
    pausing: 'pausing',
    paused: 'paused',
    pending_deletion: 'pending_deletion',
    provisioning: 'provisioning',
    provisioned: 'provisioned',
    running: 'running',
    starting: 'starting',
    terminating: 'terminating',
    terminated: 'terminated'
  }

  has_paper_trail
  belongs_to :cluster
  belongs_to :user

  has_many :addon_subscriptions
  has_many :addons, through: :addon_subscriptions
  accepts_nested_attributes_for :addon_subscriptions

  before_create :generate_slug

  acts_as_taggable_on :tags

  private
  def generate_slug
    self.slug = Haiku.call(variant: -> { SecureRandom.alphanumeric(5).downcase })
  end
end
