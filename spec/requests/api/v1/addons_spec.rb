# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Get Addons', type: :request do
  let(:application) { FactoryBot.create('doorkeeper/application') }
  let(:user)        { FactoryBot.create(:user) }
  let(:token)       { FactoryBot.create('doorkeeper/access_token', application:, resource_owner_id: user.id, scopes: 'read_addons') }

  describe 'GET /api/v1/addons' do
    it 'returns all addons' do
      FactoryBot.create_list(:addon, 10)
      get '/api/v1/addons', params: {}, headers: {
        Authorization: "Bearer #{token.token}",
        Accept: 'application/json'
      }
      expect(json['addons'].size).to eq(Addon.count)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /api/v1/addons/{addonId}' do
    it 'returns expected addon' do
      FactoryBot.create_list(:addon, 2)
      addon = Addon.first
      get "/api/v1/addons/#{addon.id}", params: {}, headers: {
        Authorization: "Bearer #{token.token}",
        Accept: 'application/json'
      }
      addon = Addon.first
      expect(json['addon']['id']).to eq(addon.id)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /api/v1/addons without authentication' do
    before do
      get '/api/v1/addons', params: {}, headers: {
        Accept: 'application/json'
      }
    end

    it 'returns 401' do
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'POST /api/v1/addons' do
    it 'requires an admin token' do
      post '/api/v1/addons', params: {
        addon: {

        }
      }

      expect(response).to have_http_status(:unauthorized)

      post '/api/v1/addons', params: {
        addon: {}
      }, headers: {
        Authorization: "Bearer #{token.token}",
      }
      expect(response).to have_http_status(:forbidden)
    end

    it 'creates an addon' do
      admin = FactoryBot.create(:user, admin: true)
      admin_token = FactoryBot.create('doorkeeper/access_token', application:, resource_owner_id: admin.id, scopes: 'manage_addons')

      post '/api/v1/addons', params: {
        addon: {
          name: "redis",
          oci_registry: "ghcr.io/launchboxio/addons/redis",
          oci_version: "latest",
          pull_policy: "Always",
          activation_policy: "Manual",
        }
      }, headers: {
        Authorization: "Bearer #{admin_token.token}",
      }

      expect(response).to have_http_status(:success)
      expect(json['addon']['name']).to eq('redis')
      expect(json['addon']['oci_registry']).to eq('ghcr.io/launchboxio/addons/redis')
      expect(json['addon']['oci_version']).to eq('latest')
      expect(json['addon']['pull_policy']).to eq('Always')
      expect(json['addon']['activation_policy']).to eq('Manual')
    end
  end

  describe 'PATCH /api/v1/addons' do
    addon = FactoryBot.create(:addon)
    it 'requires an admin token' do
      patch "/api/v1/addons/#{addon.id}", params: {
        addon: { }
      }

      expect(response).to have_http_status(:unauthorized)

      patch "/api/v1/addons/#{addon.id}", params: {
        addon: {}
      }, headers: {
        Authorization: "Bearer #{token.token}",
      }
      expect(response).to have_http_status(:forbidden)
    end

    it 'updates an addon' do
      admin = FactoryBot.create(:user, admin: true)
      admin_token = FactoryBot.create('doorkeeper/access_token', application:, resource_owner_id: admin.id, scopes: 'manage_addons')

      patch "/api/v1/addons/#{addon.id}", params: {
        addon: {
          oci_version: "1.0.0"
        }
      }, headers: {
        Authorization: "Bearer #{admin_token.token}",
      }

      expect(response).to have_http_status(:success)
      expect(json['addon']['oci_version']).to eq('1.0.0')
    end
  end

end
