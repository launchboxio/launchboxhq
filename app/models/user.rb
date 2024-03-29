# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  devise :omniauthable, omniauth_providers: %i[github gitlab bitbucket]

  has_many :projects

  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all

  has_one :profile
  has_many :vcs_connections

  has_many :repositories
  has_many :services, through: :repositories

  def active_for_authentication?
    super and activated?
  end

  def inactive_message
    "This account hasn't been activated yet"
  end
end
