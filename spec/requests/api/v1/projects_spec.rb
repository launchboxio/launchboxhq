# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Projects', type: :request do
  let(:application) { FactoryBot.create('doorkeeper/application') }
  let(:user)        { FactoryBot.create(:user) }
  let(:cluster)     { FactoryBot.create(:cluster, oauth_application_id: application.id) }
  let(:token)       { FactoryBot.create('doorkeeper/access_token', application: application, scopes: 'manage_clusters') }
  let(:project)     { FactoryBot.create(:project, cluster:, user:)}

  describe 'POST /api/v1/projects/ID' do
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
end
