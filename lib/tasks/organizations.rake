# frozen_string_literal: true

namespace :organizations do
  desc 'Ensure all users have initial organization'
  task create: :environment do
    User.where.missing(:organizations).each do |user|
      # Ensure the organization is created
      Organization.create!(name: user.email, email: user.email, is_verified: true, plan: 'free', organization_type: 'personal') unless Organization.where(name: user.email).exists?
      organization = Organization.where(name: user.email).first

      organization.memberships.create(user:)
    end
  end
end
