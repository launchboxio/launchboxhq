require 'rails_helper'

RSpec.describe 'Api::V1::ProjectAddons', type: :request do
  describe 'PATCH /api/v1/projects/ID/addons' do
    let(:application) { FactoryBot.create('doorkeeper/application') }
    let(:user) { FactoryBot.create(:user) }
    let(:cluster) { FactoryBot.create(:cluster, oauth_application_id: application.id) }
    let(:token)  { FactoryBot.create('doorkeeper/access_token', application:, scopes: 'manage_clusters') }
    let(:project) { FactoryBot.create(:project, cluster: , user: )}
    let(:addon) { FactoryBot.create(:addon)}
    let(:sub) { FactoryBot.create(:addon_subscription, project: , addon: )}

    it 'allows a cluster to update installation status' do
      patch api_v1_project_addon_path(project, sub), params: {
        project_addon: {
          status: "installed"
        }
      }, headers: {
        Authorization: "Bearer #{token.token}"
      }

      expect(json['project_addon']['status']).to eq('installed')
    end
  end
end
