# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create clusters', type: :request do
  let(:application) { FactoryBot.create('doorkeeper/application') }
  let(:user)        { FactoryBot.create(:user, admin: true) }
  let(:token)       { FactoryBot.create('doorkeeper/access_token', application:, resource_owner_id: user.id, scopes: 'manage_clusters') }

  describe 'POST /api/v1/clusters' do
    before do
      post '/api/v1/clusters', params: {
        cluster: { name: Faker::App.name }
      }, headers: {
        Authorization: "Bearer #{token.token}",
        Accept: 'application/json'
      }
    end

    it 'creates a cluster' do
      expect(response).to have_http_status(:success)
      expect(json['oauth_application_id']).not_to be_nil
      expect(json['oauth_application']['uid']).not_to be_nil
      expect(json['oauth_application']['secret']).not_to be_nil
    end
  end
end
