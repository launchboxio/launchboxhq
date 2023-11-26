# frozen_string_literal: true

class Organization < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships

  def create_and_add_user(user)
    Organization.transaction do
      create!
      memberships.create!(user:)
    end
  end
end
