# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Projects', type: :request do
  let(:application) { FactoryBot.create('doorkeeper/application') }
  let(:user) { FactoryBot.create(:user) }
  let!(:cluster) { FactoryBot.create(:cluster, oauth_application_id: application.id) }

  describe 'POST /api/v1/projects/ID' do
    let(:user)        { FactoryBot.create(:user) }
    let(:token)       { FactoryBot.create('doorkeeper/access_token', application:, scopes: 'manage_clusters') }
    let(:project)     { FactoryBot.create(:project, cluster:, user:) }
    it 'updates a project status from a cluster' do
      patch "/api/v1/projects/#{project.id}", params: {
        project: {
          status: 'provisioned',
          ca_certificate: 'some-cool-ca-certificate'
        }
      }, headers: {
        Authorization: "Bearer #{token.token}",
        Accept: 'application/json'
      }

      res = Project.find(project.id)
      expect(res.status).to eql('provisioned')
      expect(res.ca_certificate).to eql('some-cool-ca-certificate')
    end
  end

  describe 'POST /api/v1/projects' do
    let(:token) { FactoryBot.create('doorkeeper/access_token', resource_owner_id: user.id, scopes: 'manage_projects') }

    it 'creates a project' do
      post '/api/v1/projects', params: {
        project: {
          name: 'test-project'
        }
      }, headers: {
        Authorization: "Bearer #{token.token}"
      }

      expect(response).to have_http_status(:success)
    end
  end
end
