class Space < ApplicationRecord
  belongs_to :cluster
  belongs_to :user

  has_many :addon_subscriptions
  has_many :addons, :through => :addon_subscriptions

  before_create :generate_slug

  private
  def generate_slug
    self.slug = Haiku.call(variant: -> { SecureRandom.alphanumeric(5).downcase })
  end
end
