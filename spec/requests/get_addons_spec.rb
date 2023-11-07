# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Get Addons', type: :request do
  before { host! 'api.lvh.me' }
  let(:application) { FactoryBot.create('doorkeeper/application') }
  let(:user)        { FactoryBot.create(:user) }
  let(:token)       { FactoryBot.create('doorkeeper/access_token', application:, resource_owner_id: user.id, scopes: 'read_addons') }

  describe 'GET /api/v1/addons' do
    before do
      FactoryBot.create_list(:addon, 10)
      get '/api/v1/addons', params: {}, headers: {
        Authorization: "Bearer #{token.token}",
        Accept: 'application/json'
      }
    end

    it 'returns all addons' do
      expect(json['addons'].size).to eq(10)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /api/v1/addons/{addonId}' do
    before do
      FactoryBot.create_list(:addon, 2)
      addon = Addon.first
      get "/api/v1/addons/#{addon.id}", params: {}, headers: {
        Authorization: "Bearer #{token.token}",
        Accept: 'application/json'
      }
    end

    it 'returns expected addon' do
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
end
