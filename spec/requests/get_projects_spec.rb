# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Get Projects', type: :request do
  before { host! 'api.lvh.me' }
  let(:application) { FactoryBot.create('doorkeeper/application') }
  let(:user)        { FactoryBot.create(:user) }
  let(:token)       { FactoryBot.create('doorkeeper/access_token', application:, resource_owner_id: user.id, scopes: 'read_projects') }
  let(:cluster)     { FactoryBot.create(:cluster) }
  let(:project)     { FactoryBot.create(:project, cluster:, user:) }

  describe 'GET /v1/projects' do
    before do
      FactoryBot.create_list(:project, 10, cluster:, user:)
      get '/v1/projects', params: {}, headers: {
        Authorization: "Bearer #{token.token}",
        Accept: 'application/json'
      }
    end

    it 'returns all projects' do
      expect(json.size).to eq(10)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /v1/projects/{projectId}' do
    before do
      get "/v1/projects/#{project.id}", params: {}, headers: {
        Authorization: "Bearer #{token.token}",
        Accept: 'application/json'
      }
    end

    it 'returns expected project' do
      project = Project.first
      expect(json['id']).to eq(project.id)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /v1/projects without authentication' do
    before do
      get '/v1/projects', params: {}, headers: {
        Accept: 'application/json'
      }
    end

    it 'returns 401' do
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
