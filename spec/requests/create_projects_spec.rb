# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create projects', type: :request do
  before { host! 'api.lvh.me' }
  let(:application) { FactoryBot.create('doorkeeper/application') }
  let(:user)        { FactoryBot.create(:user) }
  let(:token)       { FactoryBot.create('doorkeeper/access_token', application:, resource_owner_id: user.id, scopes: 'manage_clusters manage_projects') }
  let(:cluster)     { FactoryBot.create(:cluster) }

  describe 'POST /v1/projects' do
    before do
      expect(Projects::CreateProjectJob).to receive(:perform_later).once
      post '/v1/projects', params: {
        project: {
          name: Faker::App.name,
          memory: 8192,
          cpu: 4,
          disk: 100
        },
        cluster_id: cluster.id
      }, headers: {
        Authorization: "Bearer #{token.token}",
        Accept: 'application/json'
      }
      @project_id = json['id']
    end

    it 'creates a project' do
      expect(response).to have_http_status(:success)
      expect(json['cluster_id']).to eql(cluster.id)
      expect(json['memory']).to eql(8192)
      expect(json['cpu']).to eql(4)
      expect(json['disk']).to eql(100)
    end

    it 'pauses and resumes' do
      expect(Projects::PauseProjectJob).to receive(:perform_later).once
      post "/v1/projects/#{@project_id}/pause", params: {}, headers: {
        Authorization: "Bearer #{token.token}",
        Accept: 'application/json'
      }
      expect(response).to have_http_status(:success)
      expect(json['status']).to eql('pausing')

      expect(Projects::ResumeProjectJob).to receive(:perform_later).once
      post "/v1/projects/#{@project_id}/resume", params: {}, headers: {
        Authorization: "Bearer #{token.token}",
        Accept: 'application/json'
      }
      expect(response).to have_http_status(:success)
      expect(json['status']).to eql('starting')
    end
  end
end
